#include <iostream>
#include <string>
#include <list>

using namespace std;

class YouTubeChannel {
private:
    string Name;
    string OwnerName;
    int SubscriptionsCount;
    list <string> PublishedVidioTitles;

public:
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

    void subscribe(){
        SubscriptionsCount++;
    }

    void unsubscribe(){
        if(SubscriptionsCount > 0)
            SubscriptionsCount--;
    }
    void publishVideo(string title){
        PublishedVidioTitles.push_back(title);
    }
};

int main(){

    YouTubeChannel ytChannel("AntLinux", "Anton");
    ytChannel.publishVideo("Linux kernal");
    ytChannel.publishVideo("FPGA systemverilog");
    ytChannel.publishVideo("Linux ubuntu setup");
    ytChannel.subscribe();
    ytChannel.GetInfo();

}