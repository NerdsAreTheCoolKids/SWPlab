package main

import (
	"fmt"
	"strings"
	"math/rand"
)

type RomanLetter rune

func main() {

	//task 3a
    var letter = []RomanLetter{'m', 'l', 'M', 'v', 'i', 'c', 'D'}
    var i, v, x, l, c, d, m int
	i, v, x, l, c, d, m = task3a(letter)
    fmt.Println("I: ", i)
	fmt.Println("V: ", v)
	fmt.Println("X: ", x)
	fmt.Println("L: ", l)
	fmt.Println("C: ", c)
	fmt.Println("D: ", d)
	fmt.Println("M: ", m)

    // task 3b
    low := 1
    high := 1000
    n := 10
    romanNumbers := task3b(low, high, n)
    for index := 0; index < n; index++ {
        fmt.Println(romanLettersToString(romanNumbers[index]))
    }

    // Test 1
    r, ok := task3c("mIxxClM")
    fmt.Printf("Test 2: %q -> %q (ok=%v)\n", "mIxxClM", romanLettersToString(r), ok)

    // Testfall 2
    r2, ok2 := task3c("LDCy")
    fmt.Printf("Test 3: %q -> %q (ok=%v)\n", "LDCy", romanLettersToString(r2), ok2)
}

func romanLettersToString(romanLetters []RomanLetter) string {
    readable := ""
    for i := 0; i < len(romanLetters); i++ {
        readable += string(romanLetters[i]) + " "
    }
    return readable
}

// Implement a function that counts the number of occurrences of roman letters in a roman numeral.
func task3a(letter []RomanLetter) (int, int, int, int, int, int, int) {
	i := 0
	v := 0
	x := 0
	l := 0
	c := 0
	d := 0
	m := 0
	for index := 0; index < len(letter); index++ {
		switch letter[index] {
		case 'I', 'i':
			i++
		case 'V', 'v':
			v++
		case 'X', 'x':
			x++
		case 'L', 'l':
			l++
		case 'C', 'c':
			c++
		case 'D', 'd':
			d++
		case 'M', 'm':
			m++
		}
	}
	return i, v, x, l, c, d, m

}

// Generate n roman numerals where the value of each roman numeral shall be in between low and high.
func task3b(low int, high int, n int) [][]RomanLetter {
	var bigSlice [][]RomanLetter
	for i := 0; i < n; i++ {
		var numberToConvert int = rand.Intn(high-low+1) + low
		smallSlice := convertToRomanLetter(numberToConvert)
		bigSlice = append(bigSlice, smallSlice)
	}

	return bigSlice
}

func convertToRomanLetter(diggit int) []RomanLetter {
	var smallSlice []RomanLetter
	var value = []int{1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1}
	var roman = []string{"M", "CM", "D", "CD", "C", "XC", "L", "XL", "X", "IX", "V", "IV", "I"}

	var diggitCopy int = diggit
	for i := 0; i < len(value); i++ {
		for diggitCopy >= value[i] {
			romanNumber := roman[i]
			for _, e := range(romanNumber){
				smallSlice = append(smallSlice, RomanLetter(e))
			}
			diggitCopy -= value[i]
		}
	}
	return smallSlice
}

// Implement a parser for roman numerals that accepts a mix of lowercase and uppercase letters.
func task3c(s string) ([]RomanLetter, bool) {
	var result []RomanLetter
	splittedString := strings.Split(s, "")

	for _, e := range(splittedString) {
		switch e {
		case "I", "i":
			result = append(result, RomanLetter('I'))
		case "V", "v":
			result = append(result, RomanLetter('V'))
		case "X", "x":
			result = append(result, RomanLetter('X'))
		case "L", "l":
			result = append(result, RomanLetter('L'))
		case "C", "c":
			result = append(result, RomanLetter('C'))
		case "D", "d":
			result = append(result, RomanLetter('D'))
		case "M", "m":
			result = append(result, RomanLetter('M'))
		default:
			return nil, false
		}
	}
	return result, true
}
