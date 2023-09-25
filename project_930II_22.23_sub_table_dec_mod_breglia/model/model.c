#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>
// Function to perform substitution based on the key and ciphertext characters
void substitution(const uint8_t key[12], uint8_t plaintext[1], const uint8_t ciphertext1, const uint8_t ciphertext2, const bool upper_lower, uint8_t error_key[1], uint8_t error_ciphertext[1]) {
    
    bool found = false;
    uint8_t i = 0x00;
    uint8_t j = 0x00;
    // loop to check if key is valid
    for (i = 0; i < 12; i++) {
        if((!(key[i] >= 'a' && key[i] <= 'z') ||
                (key[i] >= 'A' && key[i] <= 'Z') ||
                (key[i] >= '0' && key[i] <= '9'))){
                found = true; // not admitted character found
                break;
        }
        for (j = i + 1; j < 12; j++) {
            if (key[i] == key[j]) {
                found = true; // repeated character found
                break;
            }
            
        }
    }
    
    if(found) error_key[0] = 1; // invalid key
    else error_key[0] = 0;
    found = false;
    // check if ciphertext characters are valid
    if((!(ciphertext1 >= 'a' && ciphertext1 <= 'z') ||
    (ciphertext1 >= 'A' && ciphertext1 <= 'Z') ||
    (ciphertext1 >= '0' && ciphertext1 <= '9')) && 
    !((ciphertext2 >= 'a' && ciphertext2 <= 'z') ||
    (ciphertext2 >= 'A' && ciphertext2 <= 'Z') ||
    (ciphertext2 >= '0' && ciphertext2 <= '9'))){
        found = 1;
    }

    if(found) error_ciphertext[0] = 1; // invalid ciphertext
    else error_ciphertext[0] = 0;
    found = 0;
    
    if(error_key[0] == 0 && error_ciphertext[0] == 0){
        if(upper_lower == 1){
            // matrix that implement substitution table for uppercase
            char combinations_upper[36][3] = {
                {0, 10, 'A'}, {0, 8, 'B'}, {0, 1, 'C'}, {0, 2, 'D'}, {0, 4, 'E'}, {0, 7, 'F'},
                {11, 10, 'G'}, {11, 8, 'H'}, {11, 1, 'I'}, {11, 2, 'J'}, {11 , 4, 'K'}, {11, 7, 'L'},
                {9, 10, 'M'}, {9, 8, 'N'}, {9, 1, 'O'}, {9, 2, 'P'}, {9, 4, 'Q'}, {9, 7, 'R'},
                {3, 10, 'S'}, {3, 8, 'T'}, {3, 1, 'U'}, {3, 2, 'V'}, {3, 4, 'W'}, {3, 7, 'X'},
                {5, 10, 'Y'}, {5, 8, 'Z'}, {5, 1, '0'}, {5, 2, '1'}, {5, 4, '2'}, {5, 7, '3'},
                {6, 10, '4'}, {6, 8, '5'}, {6, 1, '6'}, {6, 2, '7'}, {6, 4, '8'}, {6, 7, '9'}
            };

    // Iterate over the combinations array
            for (i = 0; i < 36; i++) {
                if (key[combinations_upper[i][0]] == ciphertext1 && key[combinations_upper[i][1]] == ciphertext2) {
                    plaintext[0] = combinations_upper[i][2];  // Assign the corresponding plaintext value
                    break;  // Exit the loop once a match is found
                }
            }
        } else {
            // matrix that implement substitution table for lowercase
            char combinations_lower[36][3] = {
                {0, 10, 'a'}, {0, 8, 'b'}, {0, 1, 'c'}, {0, 2, 'd'}, {0, 4, 'e'}, {0, 7, 'f'},
                {11, 10, 'g'}, {11, 8, 'h'}, {11, 1, 'i'}, {11, 2, 'j'}, {11, 4, 'k'}, {11, 7, 'l'},
                {9, 10, 'm'}, {9, 8, 'n'}, {9, 1, 'o'}, {9, 2, 'p'}, {9, 4, 'q'}, {9, 7, 'r'},
                {3, 10, 's'}, {3, 8, 't'}, {3, 1, 'u'}, {3, 2, 'v'}, {3, 4, 'w'}, {3, 7, 'x'},
                {5, 10, 'y'}, {5, 8, 'z'}, {5, 1, '0'}, {5, 2, '1'}, {5, 4, '2'}, {5, 7, '3'},
                {6, 10, '4'}, {6, 8, '5'}, {6, 1, '6'}, {6, 2, '7'}, {6, 4, '8'}, {6, 7, '9'}
            };

    // Iterate over the combinations array
            for (i = 0; i < 36; i++) {
                if (key[combinations_lower[i][0]] == ciphertext1 && key[combinations_lower[i][1]] == ciphertext2) {
                    plaintext[0] = combinations_lower[i][2];  // Assign the corresponding plaintext value
                    break;  // Exit the loop once a match is found
                }
            }
        }

        
    }
    
}