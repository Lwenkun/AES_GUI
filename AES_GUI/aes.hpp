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

class aes {
public:
    static void aes_encrypt(std::string input_file, std::string output_file, std::string hex_key);
    static void aes_decrypt(std::string input_file, std::string output_file, std::string hex_key);
};

#endif /* aes_hpp */
