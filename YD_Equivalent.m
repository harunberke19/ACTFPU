% Transformer Homework Calculator - Yd Connection
% Based on SUBU EL-MAK Homework

clc; clear; close all;

% ==========================================
% 1. USER INPUT (Enter your digits here)
% ==========================================

str_input = input('Enter digits abc (e.g. 019): ','s'); %ON DOKUUUUZZ CORUUMMMMMM!! :DD :P CORUUUMMM NUMERO ONE CORUUMMM
vals = str_input - '0';
a = vals(1);
b = vals(2);
c = vals(3);




% ==========================================
% 2. DEFINING PARAMETERS 
% ==========================================
Sn_kVA = 20;               
Sn = Sn_kVA * 1000;        
V1_Line_kV = 15.4;         
V1_Line = V1_Line_kV * 1000; 
uk_percent = 30;           
i0_percent = 30;           

% Convert percentages to decimals
uk = uk_percent / 100;
i0 = i0_percent / 100;

% ==========================================
% 3. EFFICIENCY CALCULATION
% ==========================================
% Formula: 60 + (a+b+c) + (abc/10) 
sum_digits = a + b + c;
abc_val = a*100 + b*10 + c; 
eta_percent = 60 + sum_digits + (abc_val / 10);
eta = eta_percent / 100;

fprintf('\n==============================================\n');
fprintf('STEP 1: EFFICIENCY CALCULATION\n');
fprintf('==============================================\n');
fprintf('ID Digits: a=%d, b=%d, c=%d\n', a, b, c);
fprintf('Efficiency(%%) = 60 + (%d+%d+%d) + (%03d/10)\n', a, b, c, abc_val);
fprintf('Efficiency    = %.2f%%\n', eta_percent);
fprintf('Eta (decimal) = %.4f\n', eta);

% ==========================================
% 4. LOSS CALCULATION (Question 2)
% ==========================================
% Condition: Rated Power, PF=1, Max Efficiency [Source: 16]

PF = 1;
P_out = Sn * PF;

% Total Loss Formula derived from Efficiency = P_out / (P_out + P_loss)
P_loss = P_out * ((1/eta) - 1);

% Max Efficiency Condition: P_copper = P_iron [Source: 16]
P_sc = P_loss / 2; % Measured Short Circuit Power
P_fe = P_loss / 2; % Iron Losses

fprintf('\n==============================================\n');
fprintf('STEP 2: LOSSES (Question 2 Answers)\n');
fprintf('==============================================\n');
fprintf('P_out   = Sn * PF = %d * %d = %d W\n', Sn, PF, P_out);
fprintf('P_loss  = P_out * ((1/eta) - 1)\n');
fprintf('        = %d * ((1/%.4f) - 1) = %.2f W\n', P_out, eta, P_loss);
fprintf('Condition: Max Efficiency -> P_sc = P_fe = P_loss / 2\n');
fprintf('P_sc (Short Circuit Power) = %.2f / 2 = %.2f W\n', P_loss, P_sc);
fprintf('P_fe (Iron Losses)         = %.2f / 2 = %.2f W\n', P_loss, P_fe);

% ==========================================
% 5. CIRCUIT PARAMETERS (Question 1)
% ==========================================
fprintf('\n==============================================\n');
fprintf('STEP 3: EQUIVALENT CIRCUIT (Question 1)\n');
fprintf('Connection: Yd (Primary is STAR)\n');
fprintf('==============================================\n');

% --- A. Primary Values (Star Connection) ---
% Voltage: V_phase = V_line / sqrt(3)
V1_Phase = V1_Line / sqrt(3);
% Current: I_line = Sn / (sqrt(3)*V_line)
I1_Line = Sn / (sqrt(3) * V1_Line);
% In Star: I_phase = I_line
I1_Phase = I1_Line; 

fprintf('V1_Phase = V1_Line / sqrt(3) = %.1f / 1.732 = %.2f V\n', V1_Line, V1_Phase);
fprintf('I1_Phase = Sn / (sqrt(3)*V1_Line) = %d / (1.732*%.1f) = %.4f A\n', Sn, V1_Line, I1_Phase);

% --- B. Series Branch (Req, Xeq) ---
% Impedance Z_eq
Z_eq = (uk * V1_Phase) / I1_Phase;

% Resistance R_eq (using P_sc)
% P_sc = 3 * I_phase^2 * R_eq
R_eq = P_sc / (3 * I1_Phase^2);

% Reactance X_eq
X_eq = sqrt(Z_eq^2 - R_eq^2);

% R_1 - R_2 Couldnt add needed symbol for R_2 because compiler mixes something up i cannot figure out.
R_1 =R_2 = R_eq/2;
X_1 =X_2 = X_eq/2;

fprintf('\n--- Series Branch ---\n');
fprintf('Z_eq1 = (uk * V1_Phase) / I1_Phase\n');
fprintf('      = (%.2f * %.2f) / %.4f = %.2f Ohms\n', uk, V1_Phase, I1_Phase, Z_eq);

fprintf('R_eq1 = P_sc / (3 * I1_Phase^2)\n');
fprintf('      = %.2f / (3 * %.4f^2) = %.2f Ohms\n', P_sc, I1_Phase, R_eq);

fprintf('X_eq1 = sqrt(Z_eq1^2 - R_eq1^2)\n');
fprintf('      = sqrt(%.2f^2 - %.2f^2) = %.2f Ohms\n', Z_eq, R_eq, X_eq);
fprintf('R_1 = R_2 = R_eq/2\n');
fprintf('      =  %.2f/2 = %.2f Ohms\n', R_eq, R_1);
fprintf('X_1 = X_2 = X_eq/2\n');
fprintf('      =  %.2f/2 = %.2f Ohms\n', X_eq, X_1);


% --- C. Shunt Branch (Rc, Xm) ---
% No Load Current (Phase)
I0_Phase = i0 * I1_Phase;

% Core Resistance Rc (using P_fe)
% P_fe = 3 * V_phase^2 / Rc
Rc = (3 * V1_Phase^2) / P_fe;

% Magnetizing Reactance Xm
Iw = V1_Phase / Rc;          
Im = sqrt(I0_Phase^2 - Iw^2); 
Xm = V1_Phase / Im;

fprintf('\n--- Shunt Branch ---\n');
fprintf('I0_Phase = i0 * I1_Phase = %.2f * %.4f = %.4f A\n', i0, I1_Phase, I0_Phase);

fprintf('Rc1   = (3 * V1_Phase^2) / P_fe\n');
fprintf('      = (3 * %.2f^2) / %.2f = %.2f Ohms\n', V1_Phase, P_fe, Rc);

fprintf('Ic    = V1_Phase / Rc1 = %.2f / %.2f = %.4f A\n', V1_Phase, Rc, Iw);
fprintf('Im    = sqrt(I0^2 - Ic^2) = sqrt(%.4f^2 - %.4f^2) = %.4f A\n', I0_Phase, Iw, Im);

fprintf('Xm1   = V1_Phase / Im\n');
fprintf('      = %.2f / %.4f = %.2f Ohms\n', V1_Phase, Im, Xm);

fprintf('\n==============================================\n');
fprintf('FINAL ANSWERS\n');
fprintf('==============================================\n');
fprintf('Short Circuit Power (P_sc): %.2f W\n', P_sc);
fprintf('Iron Losses (P_fe):         %.2f W\n', P_fe);
fprintf('Series Resistance (Req1):   %.2f Ohms\n', R_eq);
fprintf('Series Reactance (Xeq1):    %.2f Ohms\n', X_eq);
fprintf('Core Resistance (Rc1):      %.2f Ohms\n', Rc);
fprintf('Magnetizing Reactance (Xm1):%.2f Ohms\n', Xm);
fprintf('==============================================\n');
