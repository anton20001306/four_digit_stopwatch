#include <iostream>
#include <string>
#include <list>

using namespace std;

class YouTubeChannel {
public:
    string Name;
    string OwnerName;
    int SubscriptionsCount;
    list <string> PublishedVidioTitles;
};

int main(){

    YouTubeChannel ytChannel;

    ytChannel.Name = "AntLinux";
    ytChannel.OwnerName = "Anton";
    ytChannel.SubscriptionsCount = 1000000;
    ytChannel.PublishedVidioTitles = {"FPGA Beginners","FPGH and ASIC","RTL verilog"};


    std::cout << "Name: " << ytChannel.Name << endl;
    cout << "OwnerName: " << ytChannel.OwnerName << endl;
    cout << "SubscriptionsCount: " << ytChannel.SubscriptionsCount << endl;
    cout << "PublishedVidioTitles:" << endl;
    for(string vidioTitle : ytChannel.PublishedVidioTitles){
        cout << vidioTitle << endl;
    };
}