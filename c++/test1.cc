#include <iostream>
#include <string>

using namespace std;

int main(){
    string name = "Anton";
    string response;
    string contact;

    cout << "Hello " << name << endl;
    cout << "how are you?" << "\n";

    getline(cin, response);
    cout << "You said: " << response << endl;

    cout << "What is your phone number?" << "\n";
    getline(cin, contact);
    cout << "Your phone number: " << contact << endl;

    return 0;
}