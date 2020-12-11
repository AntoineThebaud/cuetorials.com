package day11

import (
	"list"
	// "strconv"
	"strings"
)

iters: int | *5 @tag(iters,type=int)

// # -> 35
// . -> 46
// L -> 76

// input processing
_input: _example
// _input: _real
_lines: strings.Split(_input, "\n")
_runes: [for _, L in _lines { 
	strings.Runes(L)
}]

#GRID: [...[...int]]
_nums: #GRID & [for _, L in _lines {
	[int & 0]*len(L)
}]
nums: _nums

// _orig: [for _, l in _lines { strconv.Atoi(l) }]

Y: len(_lines)-1
YR: list.Range(0,Y+1,1)
X: len(_lines[0])-1
XR: list.Range(0,X+1,1)

#SeatsOfLife: {
	"0": {
		grid: #GRID & _nums
		same: false
		pretty: _input
	}

	// loop over iterations
	for i, _ in list.Range(0,iters,1) {
		"\(i+1)": {
			Grid: [ for y, _ in YR {
				[for x, _ in XR {
					let R = _runes[y][x]
					// floor, always 0
					if R == 46 {
						val: 0
						rune: "."
					}
					// not floor, calculate
					if R != 46 {

						// default calculations for neighbors
						_n: 0 | *last[y-1][x]
						_ne: 0 | *last[y-1][x+1]
						_e: 0 | *last[y][x+1]
						_se: 0 | *last[y+1][x+1]
						_s: 0 | *last[y+1][x]
						_sw: 0 | *last[y+1][x-1]
						_w: 0 | *last[y][x-1]
						_nw: 0 | *last[y-1][x-1]

						// sum of neighbors
						C: _n + _ne + _e + _se + _s + _sw + _w + _nw
						// current value for this cell
						c: last[x][y]
						#x: x
						#y: y

						// next value for this cell, defaults to current
						val: int | *c

						// empty becomes occupied
						if c == 0 && C == 0 {
							val: 1
						}
						// occupied becomes empty
						if c == 1 && C >= 4 {
							val: 0
						}

						if val == 0 {
							rune: "L"
						}
						if val == 1 {
							rune: "#"
						}
						
					}
				}]
			}]
			last: #SeatsOfLife["\(i)"].grid
			grid: [ for y, _ in YR { [for x, _ in XR { Grid[y][x].val }] } ]
			pretty: strings.Join([ for y, _ in YR { strings.Join([for x, _ in XR { Grid[y][x].rune }], "") } ], "\n")
			// same: grid == last
		}

	}
}
