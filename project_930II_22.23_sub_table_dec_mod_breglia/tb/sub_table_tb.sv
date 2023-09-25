/*
* @brief: SUBSTITUTION TABLE TESTBENCH MODULE
*/

`timescale 1ns / 1ps

import "DPI-C" function void substitution(byte key[12], byte plaintext[1], byte ciphertext1, byte ciphertext2, bit upper_lower, byte error_key[1], byte error_ciphertext[1]);

module CiphertextDecryptor_tb;
  // regs for the parameters of the module CiphertextDecryptor
  reg clk;
  reg rst_n;
  reg [7:0] key_byte;
  reg [3:0] byte_pos;
  reg key_byte_val;
  reg ctxt_valid;
  reg [15:0] ciphertext;
  reg ptxt_ready;
  reg [7:0] plaintext;
  reg error_flag_key;
  reg error_flag_ciphertext;
  reg upper_lower;
  reg [7:0] key_tb [0:11];
  integer j;
  byte key_c[12];
  byte plaintext_c[1];
  byte error_flag_key_c[1];
  byte error_flag_ciphertext_c[1];

  // Loading of the module
  CiphertextDecryptor dut (
    .clk(clk),
    .rst_n(rst_n),
    .key_byte (key_byte),
    .byte_pos (byte_pos),
    .key_byte_val (key_byte_val),
    .ctxt_valid(ctxt_valid),
    .ciphertext(ciphertext), 
    .ptxt_ready(ptxt_ready),
    .plaintext(plaintext),
    .error_flag_key(error_flag_key),
    .error_flag_ciphertext(error_flag_ciphertext),
    .upper_lower(upper_lower)
  );

  // Clock settings
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // Reset settings
  initial begin
    rst_n = 0;
    forever #10 rst_n = 1;
  end
  // TESTS
  initial begin
    key_byte_val = 0;
    ctxt_valid = 0;
    #25
    // Loading of the key
    key_tb = "abcdefghijkl";
    for (j=0;j<12;j=j+1) begin
         #10 key_byte = key_tb[j];
         key_byte_val = 1;
         byte_pos = j;
         key_c[j] = key_tb[j];
    end
    #10 
    key_byte_val = 0;
    /*
    TEST 1: Hello word with correct key
    */
    #10
    ctxt_valid = 1;
    upper_lower = 1;
    ciphertext[15:8] = "l";
    ciphertext[7:0] = "i"; // "H"
    substitution(key_c, plaintext_c, ciphertext[15:8], ciphertext[7:0], upper_lower, error_flag_key_c, error_flag_ciphertext_c); 
    #20
    //-------------------------------------
    $display("char from substitution function: %c", plaintext_c[0]);
    $display("char from module: %c", plaintext); 
    if(plaintext == plaintext_c[0]) begin
      $display("Plaintext of module and model are the same, the verification is correct!");
    end
    ctxt_valid = 1; 
    upper_lower = 0;
    ciphertext[15:8] = "a";
    ciphertext[7:0] = "e"; // "e"
    substitution(key_c, plaintext_c, ciphertext[15:8], ciphertext[7:0], upper_lower, error_flag_key_c, error_flag_ciphertext_c);
    #20
    //-------------------------------------
    $display("char from substitution function: %c", plaintext_c[0]);
    $display("char from module: %c", plaintext); 
    if(plaintext == plaintext_c[0]) begin
      $display("Plaintext of module and model are the same, the verification is correct!");
    end
    
    ctxt_valid = 1;
    upper_lower = 0;
    ciphertext[15:8] = "l";
    ciphertext[7:0] = "h"; // "l"
    substitution(key_c, plaintext_c, ciphertext[15:8], ciphertext[7:0], upper_lower, error_flag_key_c, error_flag_ciphertext_c);
    #20
    //-------------------------------------
    $display("char from substitution function: %c", plaintext_c[0]);
    $display("char from module: %c", plaintext); 
    if(plaintext == plaintext_c[0]) begin
      $display("Plaintext of module and model are the same, the verification is correct!");
    end
    ctxt_valid = 1;
    upper_lower = 0;
    ciphertext[15:8] = "l";
    ciphertext[7:0] = "h"; // "l"
    substitution(key_c, plaintext_c, ciphertext[15:8], ciphertext[7:0], upper_lower, error_flag_key_c, error_flag_ciphertext_c);
    #20
    //-------------------------------------
    $display("char from substitution function: %c", plaintext_c[0]);
    $display("char from module: %c", plaintext); 
    if(plaintext == plaintext_c[0]) begin
      $display("Plaintext of module and model are the same, the verification is correct!");
    end
    
    ctxt_valid = 1;
    upper_lower = 0;
    ciphertext[15:8] = "j";
    ciphertext[7:0] = "b"; // "o"
    substitution(key_c, plaintext_c, ciphertext[15:8], ciphertext[7:0], upper_lower, error_flag_key_c, error_flag_ciphertext_c);
    #20
    $display("char from substitution function: %c", plaintext_c[0]);
    $display("char from module: %c", plaintext); 
    if(plaintext == plaintext_c[0]) begin
      $display("Plaintext of module and model are the same, the verification is correct!");
    end
    ctxt_valid = 0;
    $display("TEST HELLO WORD DONE!");
    #40
    /*
    TEST 2: Ale word with correct key but with ctxt = 0 after every ciphertext character pair
    */
    #10
    
    ctxt_valid = 1;
    upper_lower = 1;
    ciphertext[15:8] = "a";
    ciphertext[7:0] = "k"; // "A" 
    substitution(key_c, plaintext_c, ciphertext[15:8], ciphertext[7:0], upper_lower, error_flag_key_c, error_flag_ciphertext_c);
    #20
    //-------------------------------------
    $display("char from substitution function: %c", plaintext_c[0]);
    $display("char from module: %c", plaintext); 
    if(plaintext == plaintext_c[0]) begin
      $display("Plaintext of module and model are the same, the verification is correct!");
    end
    ctxt_valid = 0; 
    upper_lower = 0;
    ciphertext[15:8] = "a";
    ciphertext[7:0] = "i"; // "b" 
    #20
    //-------------------------------------
    $display("ctxt: %b", ctxt_valid);
    ctxt_valid = 1;
    upper_lower = 0;
    ciphertext[15:8] = "l";
    ciphertext[7:0] = "h"; // "l"
    substitution(key_c, plaintext_c, ciphertext[15:8], ciphertext[7:0], upper_lower, error_flag_key_c, error_flag_ciphertext_c);
    #20
    //-------------------------------------
    $display("char from substitution function: %c", plaintext_c[0]);
    $display("char from module: %c", plaintext); 
    if(plaintext == plaintext_c[0]) begin
      $display("Plaintext of module and model are the same, the verification is correct!");
    end
    ctxt_valid = 0;
    upper_lower = 0;
    ciphertext[15:8] = "a";
    ciphertext[7:0] = "i"; // "b" 
    #20
    //-------------------------------------
    $display("ctxt: %b", ctxt_valid);
    ctxt_valid = 1;
    upper_lower = 0;
    ciphertext[15:8] = "a";
    ciphertext[7:0] = "e"; // "e"
    substitution(key_c, plaintext_c, ciphertext[15:8], ciphertext[7:0], upper_lower, error_flag_key_c, error_flag_ciphertext_c);
    #20
    $display("char from substitution function: %c", plaintext_c[0]);
    $display("char from module: %c", plaintext); 
    if(plaintext == plaintext_c[0]) begin
      $display("Plaintext of module and model are the same, the verification is correct!");
    end
    ctxt_valid = 0;
    $display("TEST ALE WORD DONE!");
    #40
    /*
    TEST 2: invalid key 
    */
    // Loading of the key
    key_tb = "abcdefghiakl"; // double "a"
    for (j=0;j<12;j=j+1) begin
         #10 key_byte = key_tb[j];
         key_byte_val = 1;
         byte_pos = j;
         key_c[j] = key_tb[j];
    end
    #10 
    key_byte_val = 0;
    #10 
    ctxt_valid = 1;
    upper_lower = 1;
    ciphertext[15:8] = "f";
    ciphertext[7:0] = "b"; 
    substitution(key_c, plaintext_c, ciphertext[15:8], ciphertext[7:0], upper_lower, error_flag_key_c, error_flag_ciphertext_c);
    #20
    $display("error flag key from substitution function: %b", error_flag_key_c[0]);
    $display("error flag key from module: %b", error_flag_key);
    if(error_flag_key == error_flag_key_c[0]) begin
      $display("error flag key of module and model are the same, the verification is correct!");
    end
    ctxt_valid = 0;
    $display("TEST INVALID KEY WITH REPEATING CHAR DONE!");
    #40
    /*
    TEST 3: invalid key 
    */
    // Loading of the key
    key_tb = "abc?efghijkl"; // "?" not admitted
    for (j=0;j<12;j=j+1) begin
         #10 key_byte = key_tb[j];
         key_byte_val = 1;
         byte_pos = j;
         key_c[j] = key_tb[j];
    end
    #10 
    key_byte_val = 0;
    //
    #10 
    ctxt_valid = 1;
    upper_lower = 1;
    ciphertext[15:8] = "f";
    ciphertext[7:0] = "b"; 
    substitution(key_c, plaintext_c, ciphertext[15:8], ciphertext[7:0], upper_lower, error_flag_key_c, error_flag_ciphertext_c);
    #20
    $display("error flag key from substitution function: %b", error_flag_key_c[0]);
    $display("error flag key from module: %b", error_flag_key);
    if(error_flag_key == error_flag_key_c[0]) begin
      $display("error flag key of module and model are the same, the verification is correct!");
    end
    ctxt_valid = 0;
    $display("TEST INVALID KEY WITH NOT ADMITTED CHAR DONE!");
    #40
    /*
    TEST 4: valid key, invalid ciphertext
    */
    // Loading of the key
    key_tb = "abcdefghijkl";
    for (j=0;j<12;j=j+1) begin
         #10 key_byte = key_tb[j];
         key_byte_val = 1;
         byte_pos = j;
         key_c[j] = key_tb[j];
    end
    #10
    key_byte_val = 0;
    #10 
    ctxt_valid = 1; 
    upper_lower = 0;
    ciphertext[15:8] = "#";
    ciphertext[7:0] = "@"; // Characters not admitted
    substitution(key_c, plaintext_c, ciphertext[15:8], ciphertext[7:0], upper_lower, error_flag_key_c, error_flag_ciphertext_c);
    #20
    $display("error flag ciphertext from substitution function: %b", error_flag_ciphertext_c[0]);
    $display("error flag ciphertext from module: %b", error_flag_ciphertext);
    if(error_flag_ciphertext == error_flag_ciphertext_c[0]) begin
      $display("error flag ciphertext of module and model are the same, the verification is correct!");
    end
    ctxt_valid = 0;
    $display("TEST INVALID CIPHERTEXT DONE!");
    #40
    /*
    TEST 5: valid key, valid ciphertext after previous negative tests
    */
    ctxt_valid = 1; 
    upper_lower = 1;
    ciphertext[15:8] = "a";
    ciphertext[7:0] = "i"; // "B"
    substitution(key_c, plaintext_c, ciphertext[15:8], ciphertext[7:0], upper_lower, error_flag_key_c, error_flag_ciphertext_c);
    #20
    //-------------------------------------
    $display("char from substitution function: %c", plaintext_c[0]);
    $display("char from module: %c", plaintext); 
    if(plaintext == plaintext_c[0]) begin
      $display("Plaintext of module and model are the same, the verification is correct!");
    end
    ctxt_valid = 1; 
    upper_lower = 0;
    ciphertext[15:8] = "f";
    ciphertext[7:0] = "k"; // "y"
    substitution(key_c, plaintext_c, ciphertext[15:8], ciphertext[7:0], upper_lower, error_flag_key_c, error_flag_ciphertext_c);
    #20
    //-------------------------------------
    $display("char from substitution function: %c", plaintext_c[0]);
    $display("char from module: %c", plaintext); 
    if(plaintext == plaintext_c[0]) begin
      $display("Plaintext of module and model are the same, the verification is correct!");
    end
    ctxt_valid = 1; 
    upper_lower = 0;
    ciphertext[15:8] = "a";
    ciphertext[7:0] = "e"; // "e"
    substitution(key_c, plaintext_c, ciphertext[15:8], ciphertext[7:0], upper_lower, error_flag_key_c, error_flag_ciphertext_c);
    #20
    $display("char from substitution function: %c", plaintext_c[0]);
    $display("char from module: %c", plaintext); 
    if(plaintext == plaintext_c[0]) begin
      $display("Plaintext of module and model are the same, the verification is correct!");
    end
    ctxt_valid = 0;
    $display("TEST BYE WORD AFTER NEGATIVE TESTS DONE!");
    #40
    $stop;
  end
  
endmodule
