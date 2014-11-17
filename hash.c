
int hand[11];
int hand_hash, hand_sum, hand_value;

void update_hand() {
	int pos = 1 + hand[1] / 2;
	int card = 2;

	hand_hash = hand[1] & 1 ^ ~(~0 << pos);
	hand_sum = hand[1];
	for (int i = 2; i < 11; i++) {
		hand_sum += i * hand[i];
		for (int j = 1; j < hand[i]; j++) {
			hand_hash |= 1 << (pos += i + 1 - card);
			card = i;
		}
	}
	hand_value = hand_sum + 10 * (hand[1] && hand_sum <= 11);
}

