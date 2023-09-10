#include <iostream>
#include <curl/curl.h>
#include <nlohmann/json.hpp>

using namespace std;
using json = nlohmann::json;

const string BOT_TOKEN = "YOUR_BOT_TOKEN";
const string BASE_URL = "https://api.telegram.org/bot" + BOT_TOKEN;

size_t WriteCallback(void *contents, size_t size, size_t nmemb, string *output) {
    size_t total_size = size * nmemb;
    output->append((char*)contents, total_size);
    return total_size;
}

string sendMessage(const string& chat_id, const string& text) {
    string url = BASE_URL + "/sendMessage";
    CURL *curl = curl_easy_init();
    string response;

    if (curl) {
        curl_easy_setopt(curl, CURLOPT_URL, url.c_str());
        curl_easy_setopt(curl, CURLOPT_POST, 1L);

        json message;
        message["chat_id"] = chat_id;
        message["text"] = text;

        string json_data = message.dump();
        curl_easy_setopt(curl, CURLOPT_POSTFIELDS, json_data.c_str());

        curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, WriteCallback);
        curl_easy_setopt(curl, CURLOPT_WRITEDATA, &response);

        CURLcode res = curl_easy_perform(curl);
        curl_easy_cleanup(curl);

        if (res != CURLE_OK) {
            cerr << "Curl error: " << curl_easy_strerror(res) << endl;
        }
    }

    return response;
}

int main() {
    // Your main bot logic goes here
    // You may want to implement a loop to continuously check for updates from Telegram

    return 0;
}

