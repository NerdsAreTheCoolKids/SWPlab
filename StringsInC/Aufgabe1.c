#include <stdio.h>
#include <stdlib.h>


enum Bool;
struct OldNew;

int length(char *s);
char* normalisiere(char* s);
void copy(char* s, int n, char* t);
char* copyStr(char* s);
char* putFront(char c, char* s);
char* reverse(char* s);
char* putBack(char c, char* s);
char* rev(char* s);
char* replace(char* s, struct OldNew* m, int n);
char* show(enum Bool b);
enum Bool strCmp(char* s1, char* s2);



// Anzahl aller Zeicher (ohne Null-terminator).
int length(char *s) {
	int n = 0;
	while(*s != '\0') {
		n++;
		s++;
	}

	return n;
}


// Normalisiere C String.
// 1. Eliminiere Leerzeichen.
// 2. Alle Grossbuchstaben werden in Kleinbuchstaben umgewandelt.
// 3. Kleinbuchstaben bleiben unveraendert.
// Annahme: C String besteht nur aus Klein-/Grossbuchstaben und Leerzeichen.
char* normalisiere(char* s) {
	int neededSpace = 0;
	char* temp = s;
	while (*temp != '\0') {
		if(*temp == ' ') {
			temp++;
			continue;
		}
		neededSpace++;
		temp++;
	}
	char* beginOfString = (char*)malloc(neededSpace + 1);
	char* result = beginOfString;
	while (*s != '\0') {
		if(*s == ' ') {
			s++;
			continue;
		}
		char c = *s;
        if (c >= 'A' && c <= 'Z') {
            c = c + 32;
        }
        *result = c;
		result++;
		s++;
	}
	*result = '\0';
	return beginOfString;
}


// Kopiere n Zeichen von s nach t.
// Annahme: n ist > 0
void copy(char* s, int n, char* t) {
	int i = 0;
	while(i < n) {
		t[i] = s[i];
		i++;
	}
}


// Baue neuen String welcher eine Kopie des Eingabestrings ist.
char* copyStr(char* s) {
	int neededSpace = 0;
	char* temp = s;
	while(*temp != '\0'){
	    neededSpace++;
	    temp++;
	}
	
	char* beginOfString = (char*)malloc(neededSpace + 1);
	char* endOfString = beginOfString;
	char* tempI = beginOfString;
	for(int i = 0; i < neededSpace; i++){
	 endOfString++;   
	}
	    
	copy(s, neededSpace, beginOfString);
	
	*endOfString = '\0';
	
	return beginOfString;
}

// Baue neuen String welcher mit Zeichen c startet gefolgt von allen Zeichen in s.
char* putFront(char c, char* s) {
	const int n =  length(s);
	char* r = (char*)malloc(sizeof(char) * (n+2));
	copy(s, n+1, r+1);
	r[0] = c;
	return r;
}


// Umkehrung eines Strings.
char* reverse(char* s) {
	const int n = length(s);
	char* t = (char*)malloc(n + 1);
	int i;

	for(i = 0; i < n; i++) {
		t[i] = s[n-1-i];
	}
	t[n] = '\0';

	return t;
}

// Baue neuen String welcher aus allen Zeichen in s besteht gefolgt von Zeichen c.
char* putBack(char c, char* s) {
    char* temp = s;
    int neededSpace = 0;
    while(*temp != '\0'){
        neededSpace++;
        temp++;
    }
    
    char* result = (char*) malloc(neededSpace +1);
    
	char* reversedS = reverse(s);
	char* modifiedS = putFront(c, reversedS);
	result = reverse(modifiedS);
	
	return result;
}

// Baue einen neuen String welcher die Umkehrung des Eingabestrings ist.
// Hinweis: Die Implementierung soll rekursiv sein und die Hilfsroutine putBack verwenden.
char* rev(char* s) {
	if(*s == '\0'){
	    char* empty = (char*) malloc(1);
        *empty = '\0';
        return empty;
	}
	char* reversedRest = rev(s + 1);
	char* result = putBack(*s, reversedRest);
    return result;
}


struct OldNew {
	char old;
	char new;
};


// Ersetze in einem String jedes Zeichen 'old' mit dem Zeichen 'new'.
// Die Zeichen 'old' und 'new' sind definiert in einem Array vom Typ struct OldNew.
char* replace(char* s, struct OldNew* m, int n) {
	char* copiedS = copyStr(s);
	char* temp;
	for(int i = 0; i < n; i++){
	    temp = copiedS;
	    while(*temp != '\0'){
	        if(*temp == m->old ){
	            *temp = m->new;
	        }
	        temp++;
	    }
	    m++;
	}
	return copiedS;
}

enum Bool {
	True = 1,
	False = 0
};

char* show(enum Bool b) {
	if(b == True) {
		return copyStr("True");
	} else {
		return copyStr("False");
	}
}


// Teste ob zwei Strings identisch sind.
enum Bool strCmp(char* s1, char* s2) {
	while(*s1 == *s2) {
		if(*s1 == '\0' && *s2 == '\0') {
			return True;
		}
		if(*s1 == '\0') {
			return False;
		}
		if(*s2 == '\0') {
			return False;
		}
		s1++;
		s2++;
	}

	return False;
}


void userTests() {
	printf("\n\n *** User Tests *** \n\n");

	char s1[] = "Ha Ll o o ";

	printf("\n1. %s", s1);

	printf("\n2. %s", normalisiere(s1));

	char* s2 = (char*)malloc(length("Hello")+1);

	char* s3 = copyStr("Hello");

	printf("\n3. %s", s3);


	char s4[] = "abcd";

	char* s5 = putBack('!',s4);

	printf("\n4. %s", s5);

	char* s6 = rev(s5);

	printf("\n5. %s", s6);

	char s7[] = "Aa dss fBB";

	printf("\n6. %s", s7);

	struct OldNew m[] = { {'B', 'b'}, {'s', '!'}};

	char* s8 = replace(s7, m, 2);

	printf("\n7. %s", s8);

	char s9[] = "HiHi";

	char* s10 = copyStr(s9);

	enum Bool b1 = strCmp(s9,s10);

	char* s11 = show(b1);

	printf("\n8. %s", s11);

	char s12[] = "HiHo";

	enum Bool b2 = strCmp(s10, s12);

	char* s13 = show(b2);

	printf("\n8. %s", s13);

	free(s2);
	free(s3);
	free(s5);
	free(s6);
	free(s8);
	free(s10);
	free(s11);
	free(s13);
	
	printf("\n========================================");
    printf("\n          START DER UNIT TESTS          ");
    printf("\n========================================\n");

    // --- TEST 1: normalisiere ---
    printf("\n[TEST 1] normalisiere:");
    char n1[] = "  A b C  d ";
    char* res1 = normalisiere(n1);
    printf("\n  Input:  \"%s\"", n1);
    printf("\n  Output: \"%s\" (Erwartet: \"abcd\")", res1);
    free(res1);

    // --- TEST 2: copyStr ---
    printf("\n\n[TEST 2] copyStr:");
    char* original = "Test-String";
    char* kopie = copyStr(original);
    printf("\n  Original: %s (Adresse: %p)", original, (void*)original);
    printf("\n  Kopie:    %s (Adresse: %p)", kopie, (void*)kopie);
    if (original != kopie) printf("\n  Status:   Erfolgreich (neue Speicheradresse)");
    free(kopie);

    // --- TEST 3: putBack ---
    printf("\n\n[TEST 3] putBack:");
    char* base = "Hello";
    char* appended = putBack('!', base);
    printf("\n  Input:  \"%s\" + '!'", base);
    printf("\n  Output: \"%s\" (Erwartet: \"Hello!\")", appended);
    free(appended);

    // --- TEST 4: rev (Rekursiv) ---
    printf("\n\n[TEST 4] rev (Rekursion):");
    char* r_input = "Recursion";
    char* r_res = rev(r_input);
    printf("\n  Input:  \"%s\"", r_input);
    printf("\n  Output: \"%s\" (Erwartet: \"noisruceR\")", r_res);
    
    // Test mit leerem String (Grenzfall für Rekursion)
    char* r_empty = rev("");
    printf("\n  Leerer String Test: \"%s\" (Länge: 0?)", r_empty);
    free(r_res);
    free(r_empty);

    // --- TEST 5: replace ---
    printf("\n\n[TEST 5] replace:");
    char s_replace[] = "Das ist ein Test";
    struct OldNew rules[] = { {'a', '@'}, {'e', '3'}, {'i', '1'}, {'s', '5'} };
    char* replaced = replace(s_replace, rules, 4);
    printf("\n  Input:  \"%s\"", s_replace);
    printf("\n  Output: \"%s\" (Erwartet: \"D@5 15t 31n T35t\")", replaced);
    free(replaced);

    // --- TEST 6: Kombination (Stress Test) ---
    printf("\n\n[TEST 6] Kombination:");
    // Wir normalisieren erst und drehen dann um
    char* step1 = normalisiere("A B C"); // "abc"
    char* step2 = rev(step1);            // "cba"
    printf("\n  normalisiere(\"A B C\") -> rev() -> Output: \"%s\"", step2);
   
    free(step1);
    free(step2);

    printf("\n\n========================================");
    printf("\n          TESTS ABGESCHLOSSEN           ");
    printf("\n========================================\n");

}

struct TestCase_ {
	char* input;
	char* expected;
};

typedef struct TestCase_ TC;

void runTests(TC* tc, int n, char* sut(char*)) {
	int i;

	for(i=0; i<n; i++) {
		char* result = sut(tc[i].input);
		if(True == strCmp(tc[i].expected, result)) {
			printf("\n Okay Test (%s,%s) => %s", tc[i].input,tc[i].expected, result);
		} else {
			printf("\n Fail Test (%s,%s) => %s", tc[i].input,tc[i].expected, result);
		}
		free(result);
	}

}

char* testPutBackExclam(char* s) {
    return putBack('!', s);
}

char* testReplaceExample(char* s) {
    struct OldNew m[] = { {'B', 'b'}, {'s', '!'} };
    return replace(s, m, 2);
}


void unitTests() {
    printf("\n\n *** Unit Tests *** \n\n");

    // --- Tests für normalisiere ---
    printf("\n[Testing: normalisiere]");
    TC normTests[] = {
        {"hElLo", "hello"},
        {"hEl Lo", "hello"},
        {"h  El Lo", "hello"},
        {"  A  B  ", "ab"},
        {"", ""} // Edge Case: Leerer String
    };
    runTests(normTests, 5, normalisiere);

    // --- Tests für copyStr ---
    printf("\n\n[Testing: copyStr]");
    TC copyTests[] = {
        {"Test", "Test"},
        {"Hallo Welt", "Hallo Welt"},
        {"", ""}
    };
    runTests(copyTests, 3, copyStr);

    // --- Tests für rev (Rekursiv) ---
    printf("\n\n[Testing: rev]");
    TC revTests[] = {
        {"abcd", "dcba"},
        {"hello", "olleh"},
        {"!aB", "Ba!"},
        {"", ""}
    };
    runTests(revTests, 4, rev);

    // --- Tests für putBack (via Wrapper) ---
    printf("\n\n[Testing: putBack (mit '!')]");
    TC pbTests[] = {
        {"abcd", "abcd!"},
        {"Hi", "Hi!"},
        {"", "!"}
    };
    runTests(pbTests, 3, testPutBackExclam);

    // --- Tests für replace (via Wrapper) ---
    printf("\n\n[Testing: replace (B->b, s->!)]");
    TC repTests[] = {
        {"Aa dss fBB", "Aa d!! fbb"},
        {"Boss", "bo!!"},
        {"Nix", "Nix"}
    };
    runTests(repTests, 3, testReplaceExample);

    printf("\n\n --- Alle Unit Tests abgeschlossen --- \n");
}

char* rndString() {
	int i;
	int n = (rand() % 10) + 1;
	char* s = (char*)malloc(n+1);

	for(i=0; i<n; i++) {
		int lowHigh = (rand() % 2) ? 'a' : 'A';
		int c = rand() % 26;
		s[i] = (char)(c + lowHigh);
	}
	s[n] = '\0';

	return s;
}

void invariantenTests() {
	printf("\n\n *** Invarianten Tests *** \n\n");

	int i;
	for(i=0; i<20; i++) {
		char* s = rndString();
		char* r = reverse(s);
		char* n1 = normalisiere(s);
		char* n2 = normalisiere(r);
		char* n3 = reverse(n2);

		if(True == strCmp(n1,n3)) {
			printf("\nOkay %s", s);
		} else {
			printf("\nFail %s", s);
		}

		free(s);
		free(r);
		free(n1);
		free(n2);
		free(n3);
	}



}


int main() {
	userTests();

	unitTests();

    invariantenTests();
}