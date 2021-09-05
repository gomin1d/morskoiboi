program MorskoyBoy;

uses CRT;

// Sv - SVOE
// Pr - PROTIVNIKA
const SvPX1 = 3;
const SvPY1 = 15;
const SvPX2 = 12;
const SvPY2 = 24;

const PrPX1 = 20;
const PrPY1 = 15;
const PrPX2 = 29;
const PrPY2 = 24;

Type Koords = array [0..11,0..11] of integer;

var SvKoords,PrKoords,TempKoords,ScreenKoords : Koords;
var i : integer; // schetchik
var PricelKrdX,PricelKrdY : integer;
procedure TextReload;
begin
    Window(1,1,80,40);
    TextBackground(0);
    TextColor(7);

    for i:=1 to 13 do // ochishaem dlya teksta
        writeln('                                                          ');
    GotoXY(1,1);
end;
procedure ObnovlenieTemp (var TmpKrds : Koords; x1,y1,x2,y2 : integer;isVrag : boolean);
var x,y : integer;
begin

    Window(x1, y1, x2+1, y2);
    textBackground(3);
    clrscr;
  for y:=1 to 10 do begin
    for x:=1 to 10 do begin
      if TmpKrds[x,y] = 1 then begin // ��� ��������� ������
        TextBackground(3);
        TextColor(15);
        GotoXY(x,y);
        write('*');
      end else if (TmpKrds[x,y] = 2) AND (isVrag = false) then begin // ������ ������ �������
        TextBackground(2);
        TextColor(14);
        GotoXY(x,y);
        write('#');
      end else if TmpKrds[x,y] = 3 then begin // ������ ���������� �������
        TextBackground(4);
        TextColor(15);
        GotoXY(x,y);
        write('X');
      end else if TmpKrds[x,y] = 4 then begin // ������ �������
        TextBackground(3);
        TextColor(5);
        GotoXY(x,y);
        write(Chr(149));
      end else if TmpKrds[x,y] = 5 then begin // ������� ������� | ���� �������
        TextBackground(6);
        TextColor(14);
        GotoXY(x,y);
        write('X');
      end;
    end;
    if (not y = 1) then writeln;
   end;
	ScreenKoords:=TmpKrds;
    Window(x2+1, y1, x2+1, y2);
    TextBackground(0);
    clrscr;

    TextReload;
end;
//
// ������ ���������� �������������  ����������
//

var BotX,BotX1,BotX2,BotY,BotY1,botY2,BotStorona,xNext,yNext : integer;
var next:string; //���������� ��������
var kill,BotHodEnd : boolean;


//***************
//����� ��� �����
//***************
procedure Next_vrag;

begin
    BotX:=random(10)+1; // ���������� ������������ �����
    BotY:=random(10)+1;
    while (SvKoords[BotX,BotY] = 1) or (SvKoords[BotX,BotY] = 5) or (SvKoords[BotX,BotY] = 3) do //���� �����, ���� ��� �� ��������
    begin
        BotX:=random(10)+1; // ���������� ������������ �����
        BotY:=random(10)+1;
    end;

    if (SvKoords[BotX,BotY]=0) then //���������, ����� �� � ���� (����� ������� �����������)
    begin
        SvKoords[BotX,BotY]:=1; //�������� �� ����� ������
        BotHodEnd := true; //����. ���
    end else //����� ������ � �������
    begin
        next:='Popal_vrag'; //���� ����� � �������
        SvKoords[BotX,BotY]:=5;
		ObnovlenieTemp(SvKoords,SvPX1,SvPY1,SvPX2,SvPY2,false);
		delay(1000); //�������� ���� �����
        xNext:=BotX; //����� ������� ���������� ������� � 2 ����������
        yNext:=BotY;
    end;
end;
//***************
//���� ���� �����
//***************
procedure Popal_vrag;
begin
    BotX1:=BotX; // ��� ������ ����� ������� ������ � ����� �������
    BotX2:=BotX;
    BotY1:=BotY;
    BotY2:=BotY;
    while SvKoords[BotX1-1,BotY] = 2 do //������ ������ �������, ���� �� ��������������
        BotX1:=BotX1-1;
    while SvKoords[BotX2+1,BotY] = 2 do //������ ����� �������, ���� �� ��������������
        BotX2:=BotX2+1;
    while SvKoords[BotX,BotY1-1] = 2 do //������ ������ �������, ���� �� ������������
        BotY1:=BotY1-1;
    while SvKoords[BotX,BotY2+1] = 2 do //������ ����� �������, ���� �� ������������
        BotY2:=BotY2+1;
    next:='Kill_vrag'; //�������������� �������, ��� ������� ���� ���������
    for i:=BotX1 to BotX2 do //��������� ������ ����� �������
        if SvKoords[i,BotY]=2 then //���� ���� ������� ����, �� ��� ������� �� ���������� �� ����
            next:='StoronaNew'; //������� �� ����, ���� ���� 1 ��� ��� ����������
    for i:=BotY1 to BotY2 do //��������� ������ ����� �������
        if SvKoords[BotX,i]=2 then //���� ���� ������� ����, �� ��� ������� �� ���������� �� ����
            next:='StoronaNew'; //������� �� ����, ���� ���� 1 ��� ��� ����������
end;
//*********************************************
//���� ���� ����� ||| ����� ������� ������
//*********************************************
procedure StoronaNew;
begin
        BotStorona  := random(4)+1;
        BotX        := xNext;
        BotY        := yNext;
        case BotStorona of
        1:BotX:=xNext-1;
        2:BotX:=xNext+1;
        3:BotY:=yNext-1;
        4:BotY:=yNext+1;
        end;
    while SvKoords[BotX,BotY]=1 do //�������� � ����� ������� �� ����������� ��������
    begin
        BotStorona  := random(4)+1;
        BotX        := xNext;
        BotY        := yNext;
        case BotStorona of
        1:BotX:=xNext-1;
        2:BotX:=xNext+1;
        3:BotY:=yNext-1;
        4:BotY:=yNext+1;
        end;
    end;
    next:='popal1';
end;
//*****************************************
procedure popal1;
begin
    if (SvKoords[BotX,BotY]=0) then //���������, ����� �� � ���� (����� ������� �����������)
    begin
        SvKoords[BotX,BotY]:=1; //�������� �� ����� ������
		next:='StoronaNew';
        BotHodEnd := true;
    end
    else //����� ������ � �������
    begin
        next:='popal2'; //���� ����� � �������
        SvKoords[BotX,BotY]:=5;
		ObnovlenieTemp(SvKoords,SvPX1,SvPY1,SvPX2,SvPY2,false);
		delay(1000); //�������� ���� �����
    end;
    kill:=true;
    for i:=BotX1 to BotX2 do //��������� ������ ����� �������
        if SvKoords[i,yNext]=2 then //���� ���� ������� ����, �� ��� ������� �� ���������� �� ����
            kill:=false; //������� �� ����, ���� ���� 1 ��� ��� ����������
    for i:=BotY1 to BotY2 do //��������� ������ ����� �������
        if SvKoords[xNext,i]=2 then //���� ���� ������� ����, �� ��� ������� �� ���������� �� ����
            kill:=false; //������� �� ����, ���� ���� 1 ��� ��� ����������/
    if kill=true then
        next:='Kill_vrag';
end;
//*****************************************
procedure popal2;
begin
    case BotStorona of
        1:BotX:=BotX-1;
        2:BotX:=BotX+1;
        3:BotY:=BotY-1;
        4:BotY:=BotY+1;
    end;
    if (SvKoords[BotX,BotY]=0) or (SvKoords[BotX,BotY]=1)  then //���������, ����� �� � ���� (����� ������� �����������)
    begin
        SvKoords[BotX,BotY]:=1; //�������� �� ����� ������
        next:='popal2';
        case BotStorona of
            1:BotStorona:=2;
            2:BotStorona:=1;
            3:BotStorona:=4;
            4:BotStorona:=3;
        end;
    end
    else //����� ������ � �������
    begin
        next:='popal2'; //���� ����� � �������
        SvKoords[BotX,BotY]:=5;
		ObnovlenieTemp(SvKoords,SvPX1,SvPY1,SvPX2,SvPY2,false);
		delay(1000); //�������� ���� �����
    end;
    kill:=true;
    for i:=BotX1 to BotX2 do //��������� ������ ����� �������
        if SvKoords[i,yNext]=2 then //���� ���� ������� ����, �� ��� ������� �� ���������� �� ����
            kill:=false; //������� �� ����, ���� ���� 1 ��� ��� ����������
    for i:=BotY1 to BotY2 do //��������� ������ ����� �������
        if SvKoords[xNext,i]=2 then //���� ���� ������� ����, �� ��� ������� �� ���������� �� ����
            kill:=false; //������� �� ����, ���� ���� 1 ��� ��� ����������
    if kill=true then
        next:='Kill_vrag';
end;
//***************
//���� ���� ����
//***************
procedure Kill_vrag;
var j,kol : integer;
var IfNext:boolean;
begin
    for i:=BotX1-1 to BotX2+1 do //�������� ��� �������
        for j:=BotY1-1 to BotY2+1 do
            SvKoords[i,j]:=1;
    for i:=BotX1-1 to BotX2+1 do //�������� ��� �������
        for j:=BotY1-1 to BotY2+1 do
            SvKoords[i,j]:=1;
    for i:=BotX1 to BotX2 do
    begin
        SvKoords[i,BotY]:=3; //������� ������� �� ����� �����
    end;
    for i:=BotY1 to BotY2 do
    begin
        SvKoords[BotX,i]:=3; //������� ������� �� ����� �����
    end;
	kol:=0;
	IfNext:= false;
	for i:=1 to 10 do
		for j:=1 to 10 do
			if SvKoords[i,j] = 3 then kol:=kol+1;
	if kol = 20 then
		IfNext:= true;
	if IfNext = true then
	begin
		 BotHodEnd := true;
	end else next:='Next_vrag';
	
			ObnovlenieTemp(SvKoords,SvPX1,SvPY1,SvPX2,SvPY2,false);
		delay(1000); //�������� ���� �����
end;

//
//  ��� ���������
//
procedure MainMenu; //���� �������. ��������� ��������
begin
	TextBackground(3);
	TextColor(6);
	writeln('#########################################');
	writeln('#########################################');
	writeln('####                                 ####');
	writeln('####                                 ####');
	write('####    '); TextColor(5); write('��� Enter ��� ������ ����'); TextColor(6);	writeln('    ####');
	writeln('####                                 ####');
	writeln('####                                 ####');
	writeln('#########################################');
	writeln('#########################################');
	TextBackground(0);
	TextColor(7);
end;


procedure ChertimNomera(x1,y1 : integer);
begin
    GotoXY(x1-2,y1);
    for i:=1 to 10 do  // po Y
    begin
        write(i);
        GotoXY(x1-2,y1+i);
    end;
    GotoXY(x1,y1-1);
    for i:=1 to 10 do  // po X
    begin
        write(Chr(i+64));
    end;
end;


procedure Chertezh;
var x,y : integer;
begin
    Window(1,1,80,40);
    TextBackground(0);

    ChertimNomera(SvPX1,SvPY1);
    ChertimNomera(PrPX1,PrPY1);

    GotoXY(SvPX1+4,SvPY2+1);
    write('��');
    GotoXY(PrPX1+3,PrPY2+1);
    write('����');

    Window(SvPX1, SvPY1, SvPX2, SvPY2);
    textBackground(3);
    clrscr;

    Window(PrPX1, PrPY1, PrPX2, PrPY2);
    textBackground(3);
    clrscr;

    TextReload;
end;
procedure ChertezhBot; { ������ ����������. ��� ����� }
var i,j,n,proc,size,x,x1,y,y1,storona : integer;
var ifset,IfReload : boolean;
begin
IfReload:=true;
while IfReload=true do
begin
for i:=0 to 11 do
		for j:=0 to 11 do
				PrKoords[i,j]:=0;
proc:=0;
for size:=1 to 4 do
begin
		for n:=1 to 5-size do
		begin
				while ifset=false do
				begin
						proc:=proc+1;
						if proc = 400 then
						begin
							IfReload:=true;
							break;
						end else IfReload:=false;
						ifset:=true;
						x:=random(9)+1;
						y:=random(9)+1;
						x1:=x;
						y1:=y;
						storona:=random(2);
						if storona=1 then
						begin
								x1:=x+size-1;
						end
						else y1:=y+size-1;
						if (x1<11) and (y1<11) then
						begin
								for i:=x to x1 do
										for j:=y to y1 do
												if not(PrKoords[i,j]=0) then
														ifset:=false;
						end
						else ifset:=false;
				end;
				ifset:=false;
				for i:=x-1 to x1+1 do
						for j:=y-1 to y1+1 do
								PrKoords[i,j]:=1;
				for i:=x to x1 do
						for j:=y to y1 do
								PrKoords[i,j]:=2;
		end;
	end;
	
end;
    // ������ �� ������ ��� �� �������� ����� ������� ��� �������. ������ ��.
    for x:=0 to 11 do
        for y:=0 to 11 do
            if (PrKoords[x,y] = 1) then
                PrKoords[x,y] := 0;

end;


procedure Rasstanovka;
var odn,dvuh,treh,chth,typeKor,typePov,kolKor,TempKrdX,TempKrdY,x,y : integer;
var temp : char;
var message : string;
var isTrue,IsTrue2 : boolean;
begin
    typeKor:=1;
	kolKor:=1; //� �������. ����� ��������
    ObnovlenieTemp(SvKoords,SvPX1,SvPY1,SvPX2,SvPY2,false);
    odn := 4;
    dvuh := 3;
    treh := 2;
    chth := 1;
    repeat
		//������ �������. �� ������� � ������� (���� �������)
        if kolKor = 1 then typeKor:=4
		else if (kolKor = 2) or (kolKor = 3) then typeKor:=3
		else if (kolKor > 3) and (kolKor < 7) then typeKor:=2
		else typeKor:=1;
		kolKor:=kolKor+1;
		
        if typeKor > 1 then
        begin
            ObnovlenieTemp(SvKoords,SvPX1,SvPY1,SvPX2,SvPY2,false);
            writeln('������ ',typeKor,'-��������� �������.');
            isTrue := false;
            repeat
                writeln('-------------------------------');
                writeln('��� ��������� �������?');
                writeln('1. �����������');
                writeln('2. �������������');
                readln(typePov);
                ObnovlenieTemp(SvKoords,SvPX1,SvPY1,SvPX2,SvPY2,false);
                if (typePov > 0) and (typePov < 3) then
                begin
                    isTrue := true
                end else
                    writeln('�������� ��������, ��������� ������!');
           until isTrue = true
        end else
            typePov := 1;

        ObnovlenieTemp(SvKoords,SvPX1,SvPY1,SvPX2,SvPY2,false);

        TempKoords := SvKoords;
        isTrue := false;

          // ��������� ���������� �������
            TempKrdY := 1;
            TempKrdX := 1;
         // ������ ������������ � ����������� �� ��������
            if typePov = 1 then // �����������
                for i:=1 to typeKor do
                    TempKoords[1,i] := 2
            else // �������������
                for i:=1 to typeKor do
                    TempKoords[i,1] := 2;

            ObnovlenieTemp(TempKoords,SvPX1,SvPY1,SvPX2,SvPY2,false);

            writeln('--------------- ����������� ������� ----------------');
            writeln('������������ ������� ����� ������������ �����������.');
            writeln('��� ���������� ������� Enter');

            IsTrue2 := false;
            repeat
                temp := readkey;
                message := '';
                // ����� ������� � ���������� �������, ���� �� ����� �����

                if Ord(temp) = 72 then begin // ��� ������� �����
                    TempKrdY := TempKrdY - 1; // ������� �� Y � ������� ���������
                    if typePov = 1 then begin// ����������� ���������� �������
                        for y:=TempKrdY to TempKrdY+typeKor-1 do // ��������� ��� ������ �������
                            if (y = 0) OR (y > 10) then // ���� ������� �� �������
                                message := '������� ������� �� ������� �����!';
                    end else // ������������� ���������� �������
                        if (TempKrdY = 0) OR (TempKrdY > 10) then // ���� ������� �� �������
                            message := '������� ������� �� ������� �����!';
                    if Length(message) > 0 then
                        TempKrdY := TempKrdY + 1; // ������� �� Y
                end else if Ord(temp) = 77 then begin // ������� ������
                    TempKrdX := TempKrdX + 1; // ������� �� X � ������� ���������
                    if typePov = 2 then begin// ������������� ���������� �������
                        for x:=TempKrdX to TempKrdX+typeKor-1 do // ��������� ��� ������ �������
                            if (x = 0) OR (x > 10) then // ���� ������� �� �������
                                message := '������� ������� �� ������� �����!';
                    end else // ����������� ���������� �������
                        if (TempKrdX = 0) OR (TempKrdX > 10) then // ���� ������� �� �������
                            message := '������� ������� �� ������� �����!';

                    if Length(message) > 0 then
                        TempKrdX := TempKrdX - 1; // ������� �� X
                end else if Ord(temp) = 80 then begin // ������� ����
                    TempKrdY := TempKrdY + 1; // ������� �� Y � ���������
                    if typePov = 1 then begin// ����������� ���������� �������
                        for y:=TempKrdY to TempKrdY+typeKor-1 do // ��������� ��� ������ �������
                            if (y = 0) OR (y > 10) then // ���� ������� �� �������
                                message := '������� ������� �� ������� �����!';
                    end else // ������������� ���������� �������
                        if (TempKrdY = 0) OR (TempKrdY > 10) then // ���� ������� �� �������
                            message := '������� ������� �� ������� �����!';

                    if Length(message) > 0 then
                        TempKrdY := TempKrdY - 1; // ������� �� Y
                end else if Ord(temp) = 75 then begin // ��� ������� �����
                    TempKrdX := TempKrdX - 1; // ������� �� X
                    if typePov = 2 then begin// ������������� ���������� �������
                        for x:=TempKrdX to TempKrdX+typeKor-1 do // ��������� ��� ������ �������
                            if (x = 0) OR (x > 10) then // ���� ������� �� �������
                                message := '������� ������� �� ������� �����!';
                    end else // ����������� ���������� �������
                        if (TempKrdX = 0) then // ���� ������� �� �������
                            message := '������� ������� �� ������� �����';

                    if Length(message) > 0 then
                        TempKrdX := TempKrdX + 1; // ������� �� X
                end else if Ord(temp) = 13 then begin // ������� ������

                    { ��� ���������� ������� �����������. � � ������� :3 }

                    if typePov = 1 then begin // ����������� ���������� �������
                        for y:=TempKrdY to TempKrdY+typeKor-1 do begin // ��������� ��� ������ �������
                            if SvKoords[TempKrdX,y] = 2 then begin
                                message := '����������� � ������ ��������!'
                            // ������� ���� ������
                            end else if (SvKoords[TempKrdX-1,y] = 2) OR // ���� ����� �� ������� ��� �������
                                        (SvKoords[TempKrdX+1,y] = 2) OR // ���� ������ �� ������� ��� �������
                                        (SvKoords[TempKrdX,y+1] = 2) OR // ���� ������ �� ������� ��� �������
                                        (SvKoords[TempKrdX,y-1] = 2) OR // ���� ����� �� ������� ��� �������
                                        (SvKoords[TempKrdX-1,y-1] = 2) OR // ���� ����� ����� �� ������� ��� �������
                                        (SvKoords[TempKrdX+1,y-1] = 2) OR // ���� ����� ������ �� ������� ��� �������
                                        (SvKoords[TempKrdX-1,y+1] = 2) OR // ���� ������ ����� �� ������� ��� �������
                                        (SvKoords[TempKrdX+1,y+1] = 2) then begin // ���� ������ ������ �� ������� ��� �������
                                            message := '����������� � ������ ��������!';
                                        end;
                        end;
                    end else if typePov = 2 then begin // ������������� ���������� �������
                        for x:=TempKrdX to TempKrdX+typeKor-1 do // ��������� ��� ������ �������
                            if SvKoords[x,TempKrdY] = 2 then begin
                                message := '����������� � ������ ��������!'
                            // ������� ���� ������
                            end else if (SvKoords[x-1,TempKrdY] = 2) OR // ���� ����� �� ������� ��� �������
                                        (SvKoords[x+1,TempKrdY] = 2) OR // ���� ������ �� ������� ��� �������
                                        (SvKoords[x,TempKrdY+1] = 2) OR // ���� ������ �� ������� ��� �������
                                        (SvKoords[x,TempKrdY-1] = 2) OR // ���� ����� �� ������� ��� �������
                                        (SvKoords[x-1,TempKrdY-1] = 2) OR // ���� ����� ����� �� ������� ��� �������
                                        (SvKoords[x+1,TempKrdY-1] = 2) OR // ���� ����� ������ �� ������� ��� �������
                                        (SvKoords[x-1,TempKrdY+1] = 2) OR // ���� ������ ����� �� ������� ��� �������
                                        (SvKoords[x+1,TempKrdY+1] = 2) then begin // ���� ������ ������ �� ������� ��� �������
                                            message := '����������� � ������ ��������!';
                                        end;
                    // ��� �����������!!!
                    end;
                    // ���� ���� ������, �� ��� � message! :)
                    if Length(message) > 0 then begin
                        ObnovlenieTemp(TempKoords,SvPX1,SvPY1,SvPX2,SvPY2,false);
                        writeln(message); // ��������
                    end else
                        IsTrue2 := true; // ������� ���
                end;

                if Length(message) > 0 then begin
                    ObnovlenieTemp(TempKoords,SvPX1,SvPY1,SvPX2,SvPY2,false);
                    writeln('������: ',message); // ��������
                end else begin
                    TempKoords := SvKoords;
                    // ��������� ��������� �������.
                    if typePov = 1 then begin // ����������� ���������� �������
                        for y:=TempKrdY to TempKrdY+typeKor-1 do // ��������� ��� ������ �������
                            TempKoords[TempKrdX,y] := 2;
                    end else
                        for x:=TempKrdX to TempKrdX+typeKor-1 do // ��������� ��� ������ �������
                            TempKoords[x,TempKrdY] := 2;

                    ObnovlenieTemp(TempKoords,SvPX1,SvPY1,SvPX2,SvPY2,false);
                end;
            until IsTrue2 = true; // ��������� ����������. ������ ������� ��� � ����

            if typePov = 1 then begin // ����������� ���������� �������
                for y:=TempKrdY to TempKrdY+typeKor-1 do // ��������� ��� ������ �������
                    SvKoords[TempKrdX,y] := 2;
            end else
                for x:=TempKrdX to TempKrdX+typeKor-1 do // ��������� ��� ������ �������
                    SvKoords[x,TempKrdY] := 2;

        // �� ��������� ������� ����

        case typeKor of // �������� �� ����������.
            1: odn:= odn - 1;
            2: dvuh:= dvuh - 1;
            3: treh:= treh - 1;
            4: chth:= chth - 1;
        end;

    until odn+dvuh+treh+chth = 0;
end;
function HodIgroka: integer;
var x,y,i,j,TempKrdY,TempKrdY1,TempKrdY2,TempKrdX,TempKrdX1,TempKrdX2,GameStatus : integer;
var IsTrue,IsTrue3 : boolean;
var temp : char;
var message : string;
var TempVragKoords : Koords;
begin
    TempKoords := PrKoords;
    IsTrue := false;

    TempKrdX:=PricelKrdX;
    TempKrdY:=PricelKrdY;

    ObnovlenieTemp(PrKoords,PrPX1,PrPY1,PrPX2,PrPY2,true);
    writeln('��� ������ ���� �������, �������, ����� ��� ����������.');

    repeat
        temp := readkey;
        message := '';
        // ����� ������� � ���������� �������, ���� �� ����� �����

        if Ord(temp) = 72 then begin // ��� ������� �����
            TempKrdY := TempKrdY - 1; // ������� �� Y � ������� ���������
            if (TempKrdY = 0) OR (TempKrdY > 10) then // ���� ������� �� �������
                message := '������ ������� �� ������� �����!';
            if Length(message) > 0 then
                TempKrdY := TempKrdY + 1; // ������� �� Y
        end else if Ord(temp) = 77 then begin // ������� ������
            TempKrdX := TempKrdX + 1; // ������� �� X � ������� ���������
            if (TempKrdX = 0) OR (TempKrdX > 10) then // ���� ������� �� �������
                message := '������ ������� �� ������� �����!';
            if Length(message) > 0 then
                TempKrdX := TempKrdX - 1; // ������� �� X
        end else if Ord(temp) = 80 then begin // ������� ����
            TempKrdY := TempKrdY + 1; // ������� �� Y � ���������
            if (TempKrdY = 0) OR (TempKrdY > 10) then // ���� ������� �� �������
                message := '������ ������� �� ������� �����!';
            if Length(message) > 0 then
                TempKrdY := TempKrdY - 1; // ������� �� Y
        end else if Ord(temp) = 75 then begin // ��� ������� �����
            TempKrdX := TempKrdX - 1; // ������� �� X
            if (TempKrdX = 0) then // ���� ������� �� �������
                message := '������ ������� �� ������� �����';
            if Length(message) > 0 then
                TempKrdX := TempKrdX + 1; // ������� �� X
        end else if Ord(temp) = 13 then begin // ������� ������
            // ������� ���� ���������� �������� �����.
            if PrKoords[TempKrdX,TempKrdY] = 0 then begin // ���� ������!
                PrKoords[TempKrdX,TempKrdY] := 1; // ������ ��� ������ �������
                writeln('���, ������!');
                delay(1000);
                IsTrue := true; // �������� ���
            end else if PrKoords[TempKrdX,TempKrdY] = 2 then begin // ���� ������!
                PrKoords[TempKrdX,TempKrdY] := 5; // ������ ��� ������ ������������ �������
						TextColor(5);
						TextBackground(6);
						writeln('||===||');
						write('||=O=||');
						TextColor(7);
						TextBackground(0);
						writeln('   �����!!!');
						TextColor(5);
						TextBackground(6);
						writeln('||===||');
						TextColor(7);
						TextBackground(0);
                delay(1000);
				
				TempKrdX1:=TempKrdX;
				TempKrdX2:=TempKrdX;
				TempKrdY1:=TempKrdY;
				TempKrdY2:=TempKrdY;
				while (PrKoords[TempKrdX1-1,TempKrdY] = 2) or (PrKoords[TempKrdX1-1,TempKrdY] = 5) do //������ ������ �������, ���� �� ��������������
					TempKrdX1:=TempKrdX1-1;
				while (PrKoords[TempKrdX2+1,TempKrdY] = 2) or (PrKoords[TempKrdX2+1,TempKrdY] = 5) do //������ ����� �������, ���� �� ��������������
					TempKrdX2:=TempKrdX2+1;
				while (PrKoords[TempKrdX,TempKrdY1-1] = 2) or (PrKoords[TempKrdX,TempKrdY1-1] = 5) do //������ ������ �������, ���� �� ������������
					TempKrdY1:=TempKrdY1-1;
				while (PrKoords[TempKrdX,TempKrdY2+1] = 2) or (PrKoords[TempKrdX,TempKrdY2+1] = 5) do //������ ����� �������, ���� �� ������������
					TempKrdY2:=TempKrdY2+1;
				IsTrue3:=true; //�������������� �������, ��� ������� ���� ���������
				for i:=TempKrdX1 to TempKrdX2 do //��������� ������ ����� �������
					if PrKoords[i,TempKrdY]=2 then //���� ���� ������� ����, �� ��� ������� �� ���������� �� ����
						IsTrue3:=false; //������� �� ����, ���� ���� 1 ��� ��� ����������
				for i:=TempKrdY1 to TempKrdY2 do //��������� ������ ����� �������
					if PrKoords[TempKrdX,i]=2 then //���� ���� ������� ����, �� ��� ������� �� ���������� �� ����
						IsTrue3:=false; //������� �� ����, ���� ���� 1 ��� ��� ����������

				if IsTrue3 = true then
				begin
						for i:=TempKrdX1-1 to TempKrdX2+1 do //�������� ��� �������
							for j:=TempKrdY1-1 to TempKrdY2+1 do
								PrKoords[i,j]:=1;
						for i:=TempKrdX1-1 to TempKrdX2+1 do //�������� ��� �������
							for j:=TempKrdY1-1 to TempKrdY2+1 do
								PrKoords[i,j]:=1;
						for i:=TempKrdX1 to TempKrdX2 do
						begin
							PrKoords[i,TempKrdY]:=3; //������� ������� �� ����� �����
						end;
						for i:=TempKrdY1 to TempKrdY2 do
						begin
							PrKoords[TempKrdX,i]:=3; //������� ������� �� ����� �����
						end;
						TextColor(5);
						TextBackground(4);
						writeln('||===||');
						write('||=O=||');
						TextColor(7);
						TextBackground(0);
						writeln('   ����!!!');
						TextColor(5);
						TextBackground(4);
						writeln('||===||');
						TextColor(7);
						TextBackground(0);
						delay(1000);
				end;
				IsTrue3 := false;
				
                IsTrue := false; // �������� ���
            end else
                message := '���� �������� ������!';
        end;


        if Length(message) > 0 then begin
            ObnovlenieTemp(TempVragKoords,PrPX1,PrPY1,PrPX2,PrPY2,true);
            writeln('������: ',message); // ��������
        end else begin
            TempVragKoords := PrKoords;
            // ��������� ��������� �������.
            TempVragKoords[TempKrdX,TempKrdY] := 4;

            ObnovlenieTemp(TempVragKoords,PrPX1,PrPY1,PrPX2,PrPY2,true);
            // ��������� �������, �� ��������� ���.
            PricelKrdX := TempKrdX;
            PricelKrdY := TempKrdY;
        end;


    until IsTrue = true; // ��������. ������ ������� ��� � ����

    // ��������� ����������.
    ObnovlenieTemp(PrKoords,PrPX1,PrPY1,PrPX2,PrPY2,true);

    // ������� ���� �� ����� �������
    GameStatus := 1;
    for x:=1 to 10 do
        for y:=1 to 10 do
            if (PrKoords[x,y] = 2) then begin
                GameStatus := 0;
                break;
                break;
            end;
    HodIgroka := GameStatus;
end;
function HodBota: integer;
var x,y,GameStatus : integer;
var isTrue : boolean;
begin
    BotHodEnd := false;
    repeat
        case next of
        'Next_vrag':Next_vrag;
        'Popal_vrag':Popal_vrag;
        'StoronaNew':StoronaNew;
        'popal1':popal1;
        'popal2':popal2;
        'Kill_vrag':Kill_vrag;
        end;
    until BotHodEnd = true;

    ObnovlenieTemp(SvKoords,SvPX1,SvPY1,SvPX2,SvPY2,false); // ��������� ��������� ������

    // ������� ���� �� ����� �������
    GameStatus := 2;
    for x:=1 to 10 do
        for y:=1 to 10 do
            if (SvKoords[x,y] = 2) then begin
                GameStatus := 0;
                break;
                break;
            end;
    HodBota := GameStatus;
end;
procedure Game;
var GameOver : integer;
begin
    writeln('��� ��� ������! � ��� ���� ������������ ;)');
    writeln('����� ����������� ������ ����������� �������.');
    writeln('��� �������� ����������� Enter.');
    writeln('����� ���!');
    delay(5000);
    GameOver := 0;

    // ������ ���������� ��� ������� ���� �������
    PricelKrdX := 1;
    PricelKrdY := 1;

    // ������ ��� ����
    next:='Next_vrag';

    repeat
        GameOver := HodIgroka; // ���� ���� ���������� 1 ���� ��������� ��� ��������� �������.
        if GameOver = 0 then
            GameOver := HodBota; // ���� ���� ���������� 2 ���� ��������� ��� ��������� �������.
    until GameOver > 0;

    if GameOver = 1 then
    begin
	TextColor(6);
	writeln('#### #### #### ####  ####    #');
	writeln('#  # #  # #    #     #  #   # #');
	writeln('#  # #  # #### ###   #  #   ###');
	writeln('#  # #  # #  # #    ###### #   #');
	writeln('#  # #### #### #### #    # #   #');
        delay(5000);
	TextColor(7);
	writeln;writeln;writeln;
	while (true) do
		write(random(99)+10,' ');
    end
    else
        writeln('������� � ���� �� ������������! � �� ����������!');

end;
BEGIN
    clrscr;
    randomize;
    // chertim polya
    ChertezhBot; // �� �� �� ������������ :)
	MainMenu;
	readln;
	Chertezh;
    writeln('����������� �������.');
    Delay(1000);
    Rasstanovka;
	for i:=0 to 11 do
	begin
		SvKoords[0,i]:=1;
		PrKoords[0,i]:=1;
		SvKoords[i,0]:=1;
		PrKoords[i,0]:=1;
	end;
    writeln('�������� ����!');
    TextReload;
    Delay(700);
    for i:=5 downto 1 do begin
        writeln('���� �������� ����� ',i,'!');
        delay(1000);
    end;
    TextReload;

    Game;

    readln;
    readln;
END.
