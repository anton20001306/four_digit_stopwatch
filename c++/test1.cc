#include <iostream>
#include <string>

using namespace std;

int main(){
    string name = "Anton";
    string response;

    cout << "Hello " << name << endl;
    cout << "how are you?" << "\n";

    getline(cin, response);
    cout << "You said: " << response << endl;

    return 0;
}