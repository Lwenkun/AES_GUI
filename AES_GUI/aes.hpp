//
//  aes.hpp
//  AES_GUI
//
//  Created by 李文坤 on 2017/6/3.
//  Copyright © 2017年 李文坤. All rights reserved.
//

#ifndef aes_hpp
#define aes_hpp
#include <string>

using namespace std;
typedef unsigned char byte;

class aes {
public:
    static void aes_encrypt(std::string input_file, std::string output_file, std::string hex_key);
    static void aes_decrypt(std::string input_file, std::string output_file, std::string hex_key);
private:
    static void _aes(string input, string output, string key, bool encrypt);
    static int read(ifstream* reader, byte buf[4][4]);
    static void add_padding(byte buf[], int full_size, int curr_size);
    static void write(ofstream* writer, byte state[4][4]);
};

#endif /* aes_hpp */
