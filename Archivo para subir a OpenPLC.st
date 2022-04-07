PROGRAM parcial2
  VAR
    start AT %IX100.0 : BOOL;
    stop AT %IW100.0 : BOOL;
    tanque1lleno AT %IX100.1 : BOOL;
    tanque1vacio AT %IX1002 : BOOL;
    tanque3lleno AT %IX100.3 : BOOL;
    tanque3vacio AT %IX100.4 : BOOL;
    motobomba1 AT %QX100.0 : BOOL;
    valvula1 AT %QX100.2 : BOOL;
    motor AT %QX100.1 : BOOL;
    valvula3 AT %QX100.3 : BOOL;
  END_VAR
  VAR
    inicio : BOOL;
    out1 : BOOL;
    reset1 : BOOL;
    motobombaout : BOOL;
    outtanque3 : BOOL;
    TON0 : TON;
    CTD0 : CTD;
    R_TRIG1 : R_TRIG;
  END_VAR

  inicio := NOT(stop) AND (out1 OR start);
  out1 := NOT(stop) AND (out1 OR start);
  motobomba1 := NOT(valvula1) AND (NOT(tanque1lleno) OR tanque1vacio) AND inicio;
  valvula1 := NOT(outtanque3) AND NOT(tanque1vacio) AND (motobombaout OR tanque1lleno) AND inicio;
  motobombaout := NOT(outtanque3) AND NOT(tanque1vacio) AND (motobombaout OR tanque1lleno) AND inicio;
  TON0(IN := NOT(tanque3vacio) AND (tanque3lleno OR valvula3) AND inicio, PT := T#10S);
  valvula3 := TON0.Q;
  motor := NOT(valvula3) AND NOT(tanque3vacio) AND (tanque3lleno OR valvula3) AND inicio;
  outtanque3 := (motor OR valvula3) AND inicio;
  R_TRIG1(CLK := valvula3 AND inicio);
  CTD0(CD := R_TRIG1.Q, LD := stop, PV := 10);
  stop := CTD0.Q;
END_PROGRAM


CONFIGURATION Config0

  RESOURCE Res0 ON PLC
    TASK task0(INTERVAL := T#50ms,PRIORITY := 0);
    PROGRAM instance0 WITH task0 : parcial2;
  END_RESOURCE
END_CONFIGURATION
