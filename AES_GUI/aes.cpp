//
//  main.cpp
//  AES
//
//  Created by 李文坤 on 2017/5/17.
//  Copyright © 2017年 李文坤. All rights reserved.
//

#include <iostream>
#include <fstream>
#include "aes.hpp"
#include "processor.hpp"

using namespace std;
typedef unsigned char byte;

void aes::aes_encrypt(string input_file, string output_file, string hex_key) {
    _aes(input_file, output_file, hex_key, true);
}

void aes::aes_decrypt(string input_file, string output_file, string hex_key) {
    _aes(input_file, output_file, hex_key, false);
}

// main looper
void aes::_aes(string input_file, string output_file, string hex_key, bool encrypt) {
    // init
    ifstream* reader = new ifstream(input_file, ios_base::in|ios_base::binary);
    ofstream* writer = new ofstream(output_file, ios_base::out|ios_base::binary);
    
    byte buf[4][4];
    byte buf2[4][4];
    byte (*bufptr)[4] = buf;
    byte (*bufptr2)[4] = buf2;
    
    bool padding_added = false;
    
    int size = read(reader, bufptr);
    
    processor* _processor = new processor(hex_key, encrypt);
    
    while (size > 0 || ! padding_added) {
        
        if (size < 16) {
            add_padding(reinterpret_cast<byte*>(bufptr), 16, size);
            padding_added = true;
        }
        // bufptr point to raw data, bufptr2 point to encryted data
        _processor->process(&bufptr, &bufptr2);
        // pre-read next buf
        size = read(reader, bufptr);
        
        if (!encrypt && size == 0) {
            writer->write(reinterpret_cast<char*>(bufptr2), 16 - bufptr2[3][3]);
            break;
        }
        
        write(writer, bufptr2);
    }
    
    reader->close();
    writer->close();

    if (reader) delete reader;
    if (writer) delete writer;
    if (_processor) delete _processor;
    
}

void aes::write(ofstream* writer, byte (*bytes)[4]) {
    writer->write(reinterpret_cast<char*>(bytes), 16);
}


void aes::add_padding(byte buf[], int full_size, int curr_size) {
    byte padding = full_size - curr_size;
    for (int i = curr_size; i < full_size; i++) {
        buf[i] = padding;
    }
}


// read bytes, tested
// - reader: file reader
// - buf: buffer
int aes::read(ifstream* reader, byte buf[4][4]) {
    reader->read(reinterpret_cast<char*>(buf), 16);
    int count = (int) reader->gcount();
    return count;
}


