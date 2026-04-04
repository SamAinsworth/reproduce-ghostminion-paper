#include <stdint.h>
#include <stdlib.h>

#define PAGE_SIZE 4096
#define NUM_PAGES 1024

int main() {
    uint8_t *spam_buffer = (uint8_t *)malloc(NUM_PAGES * PAGE_SIZE);
    uint8_t *target_page = (uint8_t *)malloc(PAGE_SIZE);

    // Ensure pages are mapped
    for(int i = 0; i < NUM_PAGES; i++) spam_buffer[i * PAGE_SIZE] = 1;
    target_page[0] = 1;

    for(int run = 0; run < 10000; run++) {
        // 1. Evict target_page from the TLB
        for(int i = 0; i < 64; i++) {
            volatile uint8_t d = spam_buffer[((run + i) % NUM_PAGES) * PAGE_SIZE];
        }

        // 2. Setup a massive stall for the older instruction
        volatile size_t slow_idx = spam_buffer[run % NUM_PAGES];
        for(int i = 0; i < 150; i++) {
            slow_idx = (slow_idx * 17 + 3) % PAGE_SIZE; // Artificial ALU delay
        }

        // 3. THE RACE CONDITION (Strictness Violation Trigger)
        
        // Instruction A (Older): Stalls in the LSQ waiting for slow_idx
        volatile uint8_t older_load = target_page[slow_idx];

        // Instruction B (Younger): Address is immediate. Bypasses A, 
        // accesses the TLB, misses, and installs an entry with Timestamp B.
        volatile uint8_t younger_load = target_page[0];
        
        // When A finally executes, it checks the TLB, sees the entry installed 
        // by B, and triggers: Timestamp B > Timestamp A.
    }

    free(spam_buffer);
    free(target_page);
    return 0;
}