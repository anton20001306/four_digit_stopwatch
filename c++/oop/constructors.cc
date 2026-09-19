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

    YouTubeChannel(string name, string ownerName){
        Name = name;
        OwnerName = ownerName;
        SubscriptionsCount = 0;
    }

    void GetInfo(){
           
        std::cout << "Name: " << Name << endl;
        cout << "OwnerName: " << OwnerName << endl;
        cout << "SubscriptionsCount: " << SubscriptionsCount << endl;
        cout << "PublishedVidioTitles:" << endl;
        for(string vidioTitle : PublishedVidioTitles){
            cout << vidioTitle << endl;
        };
    }
};

int main(){

    YouTubeChannel ytChannel("AntLinux", "Anton");
    ytChannel.PublishedVidioTitles.push_back("Linux kernal");
    ytChannel.PublishedVidioTitles.push_back("FPGA systemverilog");
    ytChannel.PublishedVidioTitles.push_back("Linux ubuntu setup");

    ytChannel.GetInfo();

}