(*******************************************************************************

MIT License

Copyright (c) 2020 matanai

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

*******************************************************************************)

program clock;

uses
    crt, dos; 
type
    figure = array[1..7, 1..5] of byte;
const
    ch = 'o';
var
    hour, min, sec, msec: word;
    width, height: byte;

function FigureShape(n: byte): figure;
const
    f0: figure = 
        ((1, 1, 1, 1, 1), (1, 0, 0, 0, 1), (1, 0, 0, 0, 1), (1, 2, 2, 2, 1), 
         (1, 0, 0, 0, 1), (1, 0, 0, 0, 1), (1, 1, 1, 1, 1));
    f1: figure = 
        ((2, 2, 2, 2, 1), (2, 0, 0, 0, 1), (2, 0, 0, 0, 1), (2, 2, 2, 2, 1), 
         (2, 0, 0, 0, 1), (2, 0, 0, 0, 1), (2, 2, 2, 2, 1));
    f2: figure = 
        ((1, 1, 1, 1, 1), (2, 0, 0, 0, 1), (2, 0, 0, 0, 1), (1, 1, 1, 1, 1), 
         (1, 0, 0, 0, 2), (1, 0, 0, 0, 2), (1, 1, 1, 1, 1));
    f3: figure = 
        ((1, 1, 1, 1, 1), (2, 0, 0, 0, 1), (2, 0, 0, 0, 1), (1, 1, 1, 1, 1), 
         (2, 0, 0, 0, 1), (2, 0, 0, 0, 1), (1, 1, 1, 1, 1));
    f4: figure = 
        ((1, 2, 2, 2, 1), (1, 0, 0, 0, 1), (1, 0, 0, 0, 1), (1, 1, 1, 1, 1), 
         (2, 0, 0, 0, 1), (2, 0, 0, 0, 1), (2, 2, 2, 2, 1));
    f5: figure= 
        ((1, 1, 1, 1, 1), (1, 0, 0, 0, 2), (1, 0, 0, 0, 2), (1, 1, 1, 1, 1), 
         (2, 0, 0, 0, 1), (2, 0, 0, 0, 1), (1, 1, 1, 1, 1));
    f6: figure = 
        ((1, 1, 1, 1, 1), (1, 0, 0, 0, 2), (1, 0, 0, 0, 2), (1, 1, 1, 1, 1), 
         (1, 0, 0, 0, 1), (1, 0, 0, 0, 1), (1, 1, 1, 1, 1));
    f7: figure = 
        ((1, 1, 1, 1, 1), (2, 0, 0, 0, 1), (2, 0, 0, 0, 1), (2, 2, 2, 2, 1), 
         (2, 0, 0, 0, 1), (2, 0, 0, 0, 1), (2, 2, 2, 2, 1));
    f8: figure = 
        ((1, 1, 1, 1, 1), (1, 0, 0, 0, 1), (1, 0, 0, 0, 1), (1, 1, 1, 1, 1), 
         (1, 0, 0, 0, 1), (1, 0, 0, 0, 1), (1, 1, 1, 1, 1));
    f9: figure = 
        ((1, 1, 1, 1, 1), (1, 0, 0, 0, 1), (1, 0, 0, 0, 1), (1, 1, 1, 1, 1), 
         (2, 0, 0, 0, 1), (2, 0, 0, 0, 1), (2, 2, 2, 2, 1));
    fcol: figure = 
        ((0, 0, 0, 0, 0), (0, 0, 0, 0, 0), (1, 0, 0, 0, 0), (0, 0, 0, 0, 0),
         (1, 0, 0, 0, 0), (0, 0, 0, 0, 0), (0, 0, 0, 0, 0));
begin
    case n of 
        0: FigureShape := f0;
        1: FigureShape := f1;
        2: FigureShape := f2;
        3: FigureShape := f3;
        4: FigureShape := f4;
        5: FigureShape := f5;
        6: FigureShape := f6;
        7: FigureShape := f7;
        8: FigureShape := f8;
        9: FigureShape := f9;
        10: FigureShape := fcol
    end
end;

procedure DrawFigure(x, y, n: byte);
var
    f: figure;
    i, j: byte;
begin
    f := FigureShape(n);
    for i := 1 to 7 do
        for j := 1 to 5 do
        begin
            gotoxy(x + j, y + i);
            case f[i, j] of 
                0: write(' ');
                1: begin textcolor(lightcyan); write(ch); end;
                2: begin textcolor(black); write(ch); end;
            end;
            gotoxy(1, 1)
        end
end;

procedure DrawClock(x, y: byte; h, m, s: word);
var
    t: array[1..3] of byte;
    i, n: byte;
begin
    t[1] := h;
    t[2] := m;
    t[3] := s;
    for i := 1 to 3 do
    begin
        n := t[i] div 10;
        DrawFigure(x, y, n);
        x := x + 8;
        n := t[i] mod 10;
        DrawFigure(x, y, n);
        x := x + 8;
        if i <> 3 then
        begin
            DrawFigure(x, y, 10);
            x := x + 4
        end
    end
end;

{main}
begin
    clrscr;
    width := (screenwidth - 52) div 2;
    height := (screenheight - 7) div 2;
    while not keypressed do
    begin
        delay(100);
        gettime(hour, min, sec, msec);
        DrawClock(width, height, hour, min, sec)   
    end;
    clrscr
end.