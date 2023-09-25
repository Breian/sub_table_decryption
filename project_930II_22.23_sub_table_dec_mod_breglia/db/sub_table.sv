/*
* @brief: SUBSTITUTION TABLE DATABASE MODULE
*/

// Module for loading the input ciphertext
module InputLoading(
   input clk,
   input rst_n,
   input wire [15:0] ciphertext,
   input wire ctxt_valid,
   input wire upper_lower,
   output reg [15:0] ciphertext_reg,
   output reg ctxt_valid_reg,
   output reg upper_lower_reg
);
  // Initialization of the input parameters: ciphertext, ctxt signal, upper/lowercase signal
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      ciphertext_reg <= 0;
      ctxt_valid_reg <= 0;
      upper_lower_reg <= 0;
    end else begin
      if(ctxt_valid) begin
        ciphertext_reg <= ciphertext;
        ctxt_valid_reg <= ctxt_valid;
        upper_lower_reg <= upper_lower;  
      end else begin
        ctxt_valid_reg <= ctxt_valid;
        upper_lower_reg <= upper_lower;
      end
    end
  end
endmodule

// Module for loading the key
module KeyLoading(
   input clk,
   input rst_n,
   input wire [7:0] key_byte, //key byte
   input wire [3:0] byte_pos, //position 
   input wire key_byte_val, //validation signal
   output reg [7:0] key [0:11],
   output reg key_valid
);

  integer i;
  
  always @(posedge clk or negedge rst_n) begin
    i = 0;
    if (!rst_n) begin
	   for (i=0;i<12;i=i+1) begin
        key[i] <= "0"; // Initialization of key byte with value 0
		end 
      key_valid <= 0;
    end else begin
      // If key_byte_val is 1, we start loading the key byte
      if (key_byte_val) begin
        key[byte_pos] <= key_byte;
      end
      if (isKeyValid(key)==0) begin
        key_valid <= 0; // Invalid key
      end else begin
        key_valid <= 1; // Valid key
      end
    end
  end
  
// Function that verify if the key has only admitted characters and no repetitions
function isKeyValid([7:0] key [0:11]);
  integer i, j, nvk;
  i = 0;
  j = 0;
  nvk = 0;
  for (i=0;i<12;i=i+1) begin
    if (!(key[i] >= "a" && key[i] <= "z" ||
         key[i] >= "A" && key[i] <= "Z" ||
         key[i] >= "0" && key[i] <= "9")) begin
      nvk = 1;	// Non-admitted character found
    end
    if (i>0) begin
       for (j=i-1;j>=0;j=j-1) begin
         if (key[i] == key[j]) begin
           nvk = 1;	// Repeated character found
         end
       end
    end
  end
  if (nvk == 0) begin
    return 1'b1; // Key is valid
  end
  else begin
    return 1'b0; // Key is not valid
  end
endfunction
  
endmodule

// Inizialitation of the table for decryption
module SubstitutionTableDecryption(
  input wire [7:0] key [0:11],
  input reg [15:0] ciphertext,
  input reg upper_lower, //signal that assert if the character of plaintext is in upper or lower case
  output reg [7:0] plaintext
);
  // Substitution word S declaration
  reg [7:0] S [0:11];
  // Inizialitation of S: initialized with the corresponding characters of key 𝐾
  always @(*) begin
    S[0]  = key[0];
    S[1]  = key[1];
    S[2]  = key[2];
    S[3]  = key[3];
    S[4]  = key[4];
    S[5]  = key[5];
    S[6]  = key[6];
    S[7]  = key[7];
    S[8]  = key[8];
    S[9]  = key[9];
    S[10] = key[10];
    S[11] = key[11];
  end
  /*
  Assignment of the output register substitution:
  each letter of the alphabet
  and the digits are substituted with the corresponding pair of 𝑆 characters in the order row-column
  */
  always @(*) begin
    if(upper_lower === 1'b1) begin
    //upper_lower == 1: UPPERCASE. upper_lower == 0: LOWERCASE.
    case ({ciphertext[15:8], ciphertext[7:0]})
      {S[0], S[10]}: plaintext = "A";
      {S[0], S[8]}: plaintext = "B";
      {S[0], S[1]}: plaintext = "C";
      {S[0], S[2]}: plaintext = "D";
      {S[0], S[4]}: plaintext = "E";
      {S[0], S[7]}: plaintext = "F";
      {S[11], S[10]}: plaintext = "G";
      {S[11], S[8]}: plaintext = "H";
      {S[11], S[1]}: plaintext = "I";
      {S[11], S[2]}: plaintext = "J";
      {S[11], S[4]}: plaintext = "K";
      {S[11], S[7]}: plaintext = "L";
      {S[9], S[10]}: plaintext = "M";
      {S[9], S[8]}: plaintext = "N";
      {S[9], S[1]}: plaintext = "O";
      {S[9], S[2]}: plaintext = "P";
      {S[9], S[4]}: plaintext = "Q";
      {S[9], S[7]}: plaintext = "R";
      {S[3], S[10]}: plaintext = "S";
      {S[3], S[8]}: plaintext = "T";
      {S[3], S[1]}: plaintext = "U";
      {S[3], S[2]}: plaintext = "V";
      {S[3], S[4]}: plaintext = "W";
      {S[3], S[7]}: plaintext = "X";
      {S[5], S[10]}: plaintext = "Y";
      {S[5], S[8]}: plaintext = "Z";
      {S[5], S[1]}: plaintext = "0";
      {S[5], S[2]}: plaintext = "1";
      {S[5], S[4]}: plaintext = "2";
      {S[5], S[7]}: plaintext = "3";
      {S[6], S[10]}: plaintext = "4";
      {S[6], S[8]}: plaintext = "5";
      {S[6], S[1]}: plaintext = "6";
      {S[6], S[2]}: plaintext = "7";
      {S[6], S[4]}: plaintext = "8";
      {S[6], S[7]}: plaintext = "9";
      default: plaintext = 0;
    endcase
    end else begin
      case ({ciphertext[15:8], ciphertext[7:0]})
      {S[0], S[10]}: plaintext = "a";
      {S[0], S[8]}: plaintext = "b";
      {S[0], S[1]}: plaintext = "c";
      {S[0], S[2]}: plaintext = "d";
      {S[0], S[4]}: plaintext = "e";
      {S[0], S[7]}: plaintext = "f";
      {S[11], S[10]}: plaintext = "g";
      {S[11], S[8]}: plaintext = "h";
      {S[11], S[1]}: plaintext = "i";
      {S[11], S[2]}: plaintext = "j";
      {S[11], S[4]}: plaintext = "k";
      {S[11], S[7]}: plaintext = "l";
      {S[9], S[10]}: plaintext = "m";
      {S[9], S[8]}: plaintext = "n";
      {S[9], S[1]}: plaintext = "o";
      {S[9], S[2]}: plaintext = "p";
      {S[9], S[4]}: plaintext = "q";
      {S[9], S[7]}: plaintext = "r";
      {S[3], S[10]}: plaintext = "s";
      {S[3], S[8]}: plaintext = "t";
      {S[3], S[1]}: plaintext = "u";
      {S[3], S[2]}: plaintext = "v";
      {S[3], S[4]}: plaintext = "w";
      {S[3], S[7]}: plaintext = "x";
      {S[5], S[10]}: plaintext = "y";
      {S[5], S[8]}: plaintext = "z";
      {S[5], S[1]}: plaintext = "0";
      {S[5], S[2]}: plaintext = "1";
      {S[5], S[4]}: plaintext = "2";
      {S[5], S[7]}: plaintext = "3";
      {S[6], S[10]}: plaintext = "4";
      {S[6], S[8]}: plaintext = "5";
      {S[6], S[1]}: plaintext = "6";
      {S[6], S[2]}: plaintext = "7";
      {S[6], S[4]}: plaintext = "8";
      {S[6], S[7]}: plaintext = "9";
      default: plaintext = 0;
    endcase
    end
  end



endmodule

/*
* @brief: DECRYPTOR MODULE
*/
// Inizialitation of the decryptor module
module CiphertextDecryptor(
  input clk,
  input rst_n,
  input wire [7:0] key_byte,
  input wire [3:0] byte_pos,
  input wire key_byte_val,
  input ctxt_valid,
  input reg [15:0] ciphertext,
  input upper_lower,
  output reg ptxt_ready,
  output reg [7:0] plaintext,
  output reg error_flag_key, // error flag to check if the key respect the requirements
  output reg error_flag_ciphertext // error flag to check if the ciphertext respect the requirements
);

// Useful regs to manage data
  reg [7:0] decrypted; // store the character of the plaintext
  reg [7:0] key [0:11]; // store the key
  reg key_valid; // store the signal that assert if the key is valid
  reg ctxt_valid_reg; // store ctxt signal
  reg upper_lower_reg; // store upper_lower signal
  reg [15:0] ciphertext_reg; // store the characters of ciphertext

/*
* Loading the previous modules passing the correct parameters
*/
InputLoading inputloading(
    .clk(clk),
    .rst_n(rst_n),
    .ciphertext(ciphertext),
    .ctxt_valid(ctxt_valid),
    .upper_lower(upper_lower),
    .ciphertext_reg(ciphertext_reg),
    .ctxt_valid_reg(ctxt_valid_reg),
    .upper_lower_reg(upper_lower_reg)
);

  KeyLoading keyloading(
   .clk (clk),
   .rst_n (rst_n),
   .key_byte (key_byte),
   .byte_pos (byte_pos),
   .key_byte_val (key_byte_val),
   .key (key),
   .key_valid (key_valid)
  );


  SubstitutionTableDecryption substitution_table(
  .key (key),
  .ciphertext (ciphertext_reg),
  .upper_lower(upper_lower_reg),
  .plaintext (decrypted)
);
// Decryption block
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      plaintext <= 0;
      error_flag_key <= 0;
      ptxt_ready <= 0;
      error_flag_key <= 0;
      error_flag_ciphertext <= 0;
    end else begin
      if (key_valid) begin
        error_flag_key <= 0;
        if (ctxt_valid_reg) begin
          if (!(isValidCharacter(ciphertext_reg[15:8]) && isValidCharacter(ciphertext_reg[7:0]))) begin
            error_flag_ciphertext <= 1; // Ciphertext error detected
            ptxt_ready <= 0;
          end else begin
            error_flag_ciphertext  <= 0;
            // Decrypt 
            plaintext <= decrypted;
            ptxt_ready <= 1;
          end
        end else begin

          error_flag_ciphertext  <= 0;
          ptxt_ready <= 0;
        end
      end else begin
        
        ptxt_ready <= 0;
     end
    end else begin
      error_flag_key <= 1;
    end
  end

// Function that verify that ciphertext has a valid character
  function isValidCharacter([7:0] input_char);
    
    begin
      isValidCharacter = ((input_char >= "a" && input_char <= "z") ||
                          (input_char >= "A" && input_char <= "Z") ||
                          (input_char >= "0" && input_char <= "9"));
    end
  endfunction

endmodule