//
//  processor.hpp
//  AES_GUI
//
//  Created by 李文坤 on 2017/6/5.
//  Copyright © 2017年 李文坤. All rights reserved.
//

#ifndef processor_hpp
#define processor_hpp

#include <string>

typedef unsigned char byte;

using namespace std;

class processor {
    
public:
    processor(string key, bool encrypt);
    ~processor();
    void process(byte (**in_bufptr)[4], byte (**out_bufptr)[4]);
    
private:
    byte sub_bytes(byte raw, byte (*s_box)[16]);
    void add_round_key(byte state[4][4], byte out_state[4][4], int k);
    void shift_rows(byte state[4][4], byte out_state[4][4], bool encrypt);
    void shift_row(byte row[], byte out_row[], int i, bool left);
    void mix_columns(byte state[4][4], byte out_state[4][4], byte (*mix_mtx)[4]);
    void expand_key(byte key[], bool encrypt);
    void _aes(string input, string output, string key, bool encrypt);
    void string2bytes(string bytes, byte out_bytes[]);
    void g(byte w[], int i, byte out_result[]);
    // store expanded key
    bool encrypt;
    byte w[11][4][4];
    byte (*buftmp)[4];
    byte* flatbytes;
};


#endif /* processor_hpp */
