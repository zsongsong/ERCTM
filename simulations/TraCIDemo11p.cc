//
// Copyright (C) 2006-2011 Christoph Sommer <christoph.sommer@uibk.ac.at>
//
// Documentation for these modules is at http://veins.car2x.org/
//
// SPDX-License-Identifier: GPL-2.0-or-later
//
// This program is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 2 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
//

#include "veins/modules/application/traci/TraCIDemo11p.h"

#include "veins/modules/application/traci/TraCIDemo11pMessage_m.h"
#include <iostream>
#include <random>
#include <chrono>
#include<fstream>
#include<sstream>
#include <stdlib.h>
using namespace veins;

Define_Module(veins::TraCIDemo11p);

void TraCIDemo11p::initialize(int stage)
{
    DemoBaseApplLayer::initialize(stage);

    if (stage == 0) {
        sentMessage = false;
        lastDroveAt = simTime();
        currentSubscribedServiceId = -1;
    }
}
double getRandom(double mean, double sigma){
    unsigned seed = std::chrono::system_clock::now().time_since_epoch().count();//每次程序运行产生不同的随机数
    std::default_random_engine gen(seed);
    std::normal_distribution<double> n(mean, sigma); //均值为0，标准差为1
    return n(gen);
}
void TraCIDemo11p::populateWSM(BaseFrame1609_4* wsm, LAddress::L2Type rcvId, int serial)
{
    wsm->setRecipientAddress(rcvId);
    wsm->setBitLength(headerLength);
    //getRandom(mean, sigma);
    //EV << "rand" << getRandom(mean, sigma)<< std::endl;
    if (DemoSafetyMessage* bsm = dynamic_cast<DemoSafetyMessage*>(wsm)) {
        int myidnum =atoi(mobility->getExternalId().c_str());

        meanP =0;meanV=0;
    //  Threat Model G
        if (myidnum>0 && myidnum<=40)
            {sigmaP=0;sigmaV=0;}
        else if(myidnum>40 && myidnum<=50)
            {sigmaP=100;sigmaV=1;}
        else if(myidnum>50 && myidnum<=60)
            {sigmaP=200;sigmaV=1;}
        else if(myidnum>60 && myidnum<=70)
            {sigmaP=100;sigmaV=3;}
        else if(myidnum>70 && myidnum<=80)
            {sigmaP=200;sigmaV=3;}
        else if(myidnum>80 && myidnum<=90)
            {sigmaP=100;sigmaV=5;}
        else
            {sigmaP=200;sigmaV=5;}

        Coord curV,curP;

        curP.x = curPosition.x +getRandom(meanP, sigmaP);
        curP.y = curPosition.y +getRandom(meanP, sigmaP);
        curV.x = mobility->getCurrentDirection().x * mobility->getSpeed()+getRandom(meanV, sigmaV);
        curV.y = mobility->getCurrentDirection().y * mobility->getSpeed()+getRandom(meanV, sigmaV);

        bsm->setSenderPos(curP);
        bsm->setSenderSpeed(curV);
        bsm->setT(simTime());
        bsm->setMyid(myidnum);
        bsm->setPsid(-1);
        bsm->setChannelNumber(static_cast<int>(Channel::cch));
        bsm->addBitLength(beaconLengthBits);
        wsm->setUserPriority(beaconUserPriority);
    }
    else if (DemoServiceAdvertisment* wsa = dynamic_cast<DemoServiceAdvertisment*>(wsm)) {
        wsa->setChannelNumber(static_cast<int>(Channel::cch));
        wsa->setTargetChannel(static_cast<int>(currentServiceChannel));
        wsa->setPsid(currentOfferedServiceId);
        wsa->setServiceDescription(currentServiceDescription.c_str());
    }
    else {
        if (dataOnSch)
            wsm->setChannelNumber(static_cast<int>(Channel::sch1)); // will be rewritten at Mac1609_4 to actual Service Channel. This is just so no controlInfo is needed
        else
            wsm->setChannelNumber(static_cast<int>(Channel::cch));
        wsm->addBitLength(dataLengthBits);
        wsm->setUserPriority(dataUserPriority);
    }
}
void TraCIDemo11p::onBSM(DemoSafetyMessage* m)
{
    simtime_t curtime;
    DemoSafetyMessage* bsm = check_and_cast<DemoSafetyMessage*>(m);

    youpo[listindex] = bsm->getSenderPos();
    yousp[listindex] = bsm->getSenderSpeed();
    yout[listindex] = bsm->getT();
    youid[listindex] = bsm->getMyid();
    curtime = simTime();

    mypo[listindex] = mobility->getPositionAt(curtime);
    mysp[listindex] = mobility->getCurrentDirection()* mobility->getSpeed();
    myt[listindex] = curtime;
    listindex = listindex + 1;
}

void TraCIDemo11p::onWSA(DemoServiceAdvertisment* wsa)
{
    if (currentSubscribedServiceId == -1) {
        mac->changeServiceChannel(static_cast<Channel>(wsa->getTargetChannel()));
        currentSubscribedServiceId = wsa->getPsid();
        if (currentOfferedServiceId != wsa->getPsid()) {
            stopService();
            startService(static_cast<Channel>(wsa->getTargetChannel()), wsa->getPsid(), "Mirrored Traffic Service");
        }
    }
}

void TraCIDemo11p::onWSM(BaseFrame1609_4* frame)
{
    TraCIDemo11pMessage* wsm = check_and_cast<TraCIDemo11pMessage*>(frame);

    findHost()->getDisplayString().setTagArg("i", 1, "green");

    if (mobility->getRoadId()[0] != ':') traciVehicle->changeRoute(wsm->getDemoData(), 9999);
    if (!sentMessage) {
        sentMessage = true;
        // repeat the received traffic update once in 2 seconds plus some random delay
        wsm->setSenderAddress(myId);
        wsm->setSerial(3);
        scheduleAt(simTime() + 2 + uniform(0.01, 0.2), wsm->dup());
    }
}

void TraCIDemo11p::handleSelfMsg(cMessage* msg)
{
    if (TraCIDemo11pMessage* wsm = dynamic_cast<TraCIDemo11pMessage*>(msg)) {
        // send this message on the service channel until the counter is 3 or higher.
        // this code only runs when channel switching is enabled
        sendDown(wsm->dup());
        wsm->setSerial(wsm->getSerial() + 1);
        if (wsm->getSerial() >= 3) {
            // stop service advertisements
            stopService();
            delete (wsm);
        }
        else {
            scheduleAt(simTime() + 1, wsm);
        }
    }
    else {
        DemoBaseApplLayer::handleSelfMsg(msg);
    }
}

void TraCIDemo11p::handlePositionUpdate(cObject* obj)
{
    DemoBaseApplLayer::handlePositionUpdate(obj);
    EV << "Pos" << mobility->getPositionAt(simTime()) << std::endl;
    EV << "Time" << simTime() << std::endl;
    // stopped for for at least 10s?
    if (mobility->getSpeed() < 1) {
        if (simTime() - lastDroveAt >= 10 && sentMessage == false) {
            findHost()->getDisplayString().setTagArg("i", 1, "red");
            sentMessage = true;

            TraCIDemo11pMessage* wsm = new TraCIDemo11pMessage();
            populateWSM(wsm);
            wsm->setDemoData(mobility->getRoadId().c_str());

            // host is standing still due to crash
            if (dataOnSch) {
                startService(Channel::sch2, 42, "Traffic Information Service");
                // started service and server advertising, schedule message to self to send later
                scheduleAt(computeAsynchronousSendingTime(1, ChannelType::service), wsm);
            }
            else {
                // send right away on CCH, because channel switching is disabled
                sendDown(wsm);
            }
        }
    }
    else {
        lastDroveAt = simTime();
    }
}
void TraCIDemo11p::finish(){
    DemoBaseApplLayer::finish();
    std::string filename;
    int myidnum =atoi(mobility->getExternalId().c_str());

    if (myidnum>0 && myidnum<=40)
        filename=std::string("car0") + "id"+std::to_string(myidnum)+".csv";
    else if(myidnum>40 && myidnum<=50)
        filename=std::string("car1") + "id"+std::to_string(myidnum)+".csv";
    else if(myidnum>50 && myidnum<=60)
        filename=std::string("car2") + "id"+std::to_string(myidnum)+".csv";
    else if(myidnum>60 && myidnum<=70)
        filename=std::string("car3") + "id"+std::to_string(myidnum)+".csv";
    else if(myidnum>70 && myidnum<=80)
        filename=std::string("car4") + "id"+std::to_string(myidnum)+".csv";
    else if(myidnum>80 && myidnum<=90)
        filename=std::string("car5") + "id"+std::to_string(myidnum)+".csv";
    else
        filename=std::string("car6") + "id"+std::to_string(myidnum)+".csv";


    //EV << "filename" << filename << std::endl;
    std::string csvPath= "results/"+filename;
    std::ofstream csvfile;
    csvfile.open(csvPath, std::ios::out);
    if (!csvfile)
    {
        //文件打开失败
        return;
    }
    //csv文件输出
    csvfile <<"youid" << ","<<"youposx"<<","<<"youposy"<<","<< "youspeedx" << "," << "youspeedy" << ","<< "youtime" << "," << "myposx"<< "," << "myposy"<< ","<< "myspeedx"<< "," << "myspeedy"<< ","<< "mytime"<< "," << "\n";
    for (int i = 0; i < listindex; i++)
    {
        csvfile << youid[i]<<','<<youpo[i].x<<','<<youpo[i].y<<","<<yousp[i].x<<','<<yousp[i].y<<','<<yout[i]<<','<<mypo[i].x<<','<<mypo[i].y<<','<<mysp[i].x<<','<<mysp[i].y<<','<<myt[i]<<','<<"\n";
    }
    csvfile.close();
}
