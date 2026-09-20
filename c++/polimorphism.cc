#include <iostream>
#include <string>
#include <list>

using namespace std;

class YouTubeChannel {
private:
    string Name;
    int SubscriptionsCount;
    list <string> PublishedVidioTitles;

protected:
    string OwnerName;
    int QualityCount;

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

    void AnalyseQuality(){
        if(QualityCount > 5)
            cout << OwnerName << " creates good quality content" << endl;
        else
            cout << "Not inough quality of content" << endl;

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

// Inheritance
class CookingYouTubeChannel:public YouTubeChannel{
public:
    // Constructor
    CookingYouTubeChannel(string name, string ownerName):YouTubeChannel(name, ownerName){

    }

    void practice(){
        cout << OwnerName << "is practicing some receipe" << endl;
        QualityCount++;
    }
};

// Inheritance
class SigingYouTubeChannel:public YouTubeChannel{
public:
    // Constructor
    SigingYouTubeChannel(string name, string ownerName):YouTubeChannel(name, ownerName){

    }

    void practice(){
        cout << OwnerName << "is singing a song" << endl;
        QualityCount++;
    }
};

int main(){

    // YouTubeChannel ytChannel("AntLinux", "Anton");
    // ytChannel.publishVideo("Linux kernal");
    // ytChannel.publishVideo("FPGA systemverilog");
    // ytChannel.publishVideo("Linux ubuntu setup");
    // ytChannel.subscribe();
    // ytChannel.GetInfo();

    CookingYouTubeChannel cookChannel1("john's kitchen","John");
    cookChannel1.GetInfo();
    cookChannel1.practice();
    cookChannel1.practice();
    cookChannel1.practice();
    cookChannel1.practice();
    cookChannel1.practice();
    cookChannel1.practice();
    cookChannel1.AnalyseQuality();

    // Ploymorphism
    YouTubeChannel *yt = &cookChannel1;
    yt->AnalyseQuality();

    SigingYouTubeChannel singChannel1("ant's lab","Ant");
    singChannel1.GetInfo();
    singChannel1.AnalyseQuality();


}