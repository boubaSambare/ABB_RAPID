%%%
  VERSION:1
  LANGUAGE:ENGLISH
%%%
MODULE DieciUtilities
!*****************************************************************************
!
!  MODULE:    DieciUtilities
!  Version:        1.0
!  Author:         sambare aboubacar
!
!
!  Description:
!                  module for cycle counter
!                  menu for to controll tcp
!
!
!  History:
!
!                  2018-12-14 Created
!
!
!  Remark:
!
!
!****************************************************************************

  VAR num nChoice:=0;
	CONST string mtitle:="SELEZIONA UN SERVIZIO :";
	CONST string tcpServ:=" Controllo torcia";
	CONST string production:=" RESET PEZZI";
	CONST string cleanP:="PULIZIA";
  VAR num answerP:=0;
  VAR errnum errvar;
  PERS ee_event peePostPart:=[13,"configurazione","",254,255];
	PERS ee_event peePostPart:=[7,"increaseProduction","",254,255];

   !configurazione
    PROC configurazione()
		nChoice := 1;
		TPErase;
		! inizio test
  WHILE nChoice <> 5 DO
					    TPWrite "Data: "+CDate()+"           Ora: "+CTime();
					    TPWrite "";
					    TPWrite "TEMPO DI PRODUZIONE = "+ ultimoBraccio;
					    TPWrite "Arco acceso         = ";
					    TPWrite "";
					    TPWrite "PRODUZIONE          = "+numToStr(contaPezzi,0)+" Pezzi";
					    TPWrite "";
							TPReadFK nChoice, mtitle, tcpServ, cleanP, production, stEmpty, "AVANTI";
				TEST nChoice
						CASE 1:
							TPErase;
							AR_TcpCheck;

						 CASE 2:
							TPErase;
							moveToClean;
							Torch_Cleaning_base;


					    CASE 3:
							TPErase;
					          TPReadFK answerP,"CONFERMA RESET CONTAPEZZI?",stEmpty,stEmpty,stEmpty,"OK","INDIETRO";
						  TEST answerP
			           CASE 4:
			              contaPezzi:= 0;
			           CASE 5:
			              configurazione;
			         ENDTEST

					ENDTEST
	ENDWHILE
		!
		nChoice := 1;
		TPErase;
	ENDPROC
	 !Procedura per incremnetare il variable contaPezzi alla fine PRODUZIONE
    PROC increaseProduction()
			Incr contaPezzi;
			TPWrite "PRODUZIONE = "+numToStr(contaPezzi,0)+"Pezzi";
	  ENDPROC
 !Procedura per visualisare su flexpendant il numero di bracci fatti
	 PROC visualProduction()
		 TPWrite "PRODUZIONE = "+numToStr(contaPezzi,0)+"Pezzi";
	 ENDPROC


    PROC moveToClean()
		! serve per muovere a un posizione sicura per la pulizia
		MoveL [[10.00,2110.54,525.49],[0.612355,-0.353589,-0.353587,-0.612349],[-1,0,0,1],[9.9961,9E+09,9E+09,9E+09,9E+09,9E+09]], v1000, z50, tool0;
		MoveJ [[9.99,2110.54,525.48],[0.612352,-0.35359,-0.35359,-0.61235],[-2,0,0,1],[9.9961,9E+09,9E+09,9E+09,9E+09,9E+09]], v1000, z50, tool0;
		MoveJ [[10.00,2110.54,525.49],[0.612352,-0.353592,-0.353589,-0.61235],[-1,0,0,1],[9.9961,9E+09,9E+09,9E+09,9E+09,9E+09]], v1000, z50, tool0;
	 ENDPROC

ENDMODULE
