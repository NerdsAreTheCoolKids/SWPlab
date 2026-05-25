package main

import (
	"fmt"
	"strings"
)

type RomanLetter string

func main() {
	var letter = []RomanLetter{"x", "l", "l", "l", "l"}
	i, v, x, l, c, d, m := task3a(letter)
	fmt.Print(i, v, x, l, c, d, m)
	fmt.Println("")

	var low int = 2222
	var high int = 2222
	var n int = 5
	romanNumbers := task3b(low, high, n)
	for index := 0; index < len(romanNumbers); index++ {
		for innerIndex := 0; innerIndex < len(romanNumbers[i]); innerIndex++ {
			fmt.Print(romanNumbers[index][innerIndex] + " ")
		}
		fmt.Println("")
	}

	s := "ABC"
	result, worked := task3c(s)

	if worked {
		for index := 0; index < len(result); index++ {
			fmt.Print(result[index])
			fmt.Println("")
		}
	} else {
		fmt.Print("False input")
		fmt.Println("")
	}

	s2 := "mLxXcI"
	result2, worked2 := task3c(s2)

	if worked2 {
		for index := 0; index < len(result2); index++ {
			fmt.Print(result2[index])
			fmt.Println("")
		}
	} else {
		fmt.Print("False input")
		fmt.Println("")
	}
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
		case "I", "i":
			i++
		case "V", "v":
			v++
		case "X", "x":
			x++
		case "L", "l":
			l++
		case "C", "c":
			c++
		case "D", "d":
			d++
		case "M", "m":
			m++
		}
	}
	return i, v, x, l, c, d, m

}

// Generate n roman numerals where the value of each roman numeral shall be in between low and high.
func task3b(low int, high int, n int) [][]RomanLetter {
	var bigSlice [][]RomanLetter
	var numberToConvert int = (high + low) / 2
	for i := 0; i < n; i++ {
		smallSlice := convertToRomanLetter(numberToConvert)
		bigSlice = append(bigSlice, smallSlice)

		numberToConvert += i
		if numberToConvert > high {
			numberToConvert = low
		}
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
			if len(romanNumber) > 1 {
				romanNumber := strings.Split(romanNumber, "")
				smallSlice = append(smallSlice, RomanLetter(romanNumber[0]))
				smallSlice = append(smallSlice, RomanLetter(romanNumber[1]))
			} else {
				smallSlice = append(smallSlice, RomanLetter(romanNumber))
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

	for i := 0; i < len(splittedString); i++ {
		switch splittedString[i] {
		case "I", "i":
			result = append(result, RomanLetter("I"))
		case "V", "v":
			result = append(result, RomanLetter("V"))
		case "X", "x":
			result = append(result, RomanLetter("X"))
		case "L", "l":
			result = append(result, RomanLetter("L"))
		case "C", "c":
			result = append(result, RomanLetter("C"))
		case "D", "d":
			result = append(result, RomanLetter("D"))
		case "M", "m":
			result = append(result, RomanLetter("M"))
		default:
			return nil, false
		}
	}
	return result, true
}
