unit binary;
{

Author : Robert Jarzabek
http://www.iSys.Pl/
http://inteligentny-dom.ehouse.pro/
http://www.eHouse.Pro/


eHouse System Controller Status analizer
One Controller Panel PC software
capture data from eHouse controllers via UDP
load and synchronize status to local software cache matrix
display status of desired controller on panel
Buttons are active and store events to email directory
can be template of any eHouse application
        control panel,
        communication server,
        gateway,
        log analizer
        etc

This source code loacation:   http://www.iSys.Pl/download/delphi/

Verified for version as of date 20121121


File contains binary status frame (definition) received via UDP or TCP directly from eHouse controllers
}
//var         CURRENT_PGM:integer;

interface
procedure    get_hm_desc;
procedure set_rm(str:array of char;TCP_INDEX_INC:integer);
procedure set_status_commmanager(statusb:array of char);
procedure set_status_ethroommanager(statusb:array of char);
function calcindex(high,low:char):integer;
const MAX_TEMP=6;
var    WENT_MODE:integer;       //binary coded ventilation mode from HM
boiler_alarm:boolean=false;   //boiler alarm above programmed alarm temperature
bonfire_stat:integer; //bonfire heating level 0-7 for binary mode
//0 - fire off
//1 - fire on / extinguishing => green level<temp jacket (green led blinking)
//2 - fire on => green level>=temp jacket>yellow level - histeressis (green led)
//3 - fire on => yellow level - histeressis>temp jacket>yellow level+ histeressis) (green + yellow leds)
//4 - fire on => yellow level +histeressis>temp jacket>red level - histeressis (yellow led)
//5 - unconditional => red level - histeressis < temp jacket < red level + histeressis (red+yellow leds)
//6 - unconditional => temp jacket > red level + histeressis     (red led constant)
//7 - unconditional => temp jacket > bonfire alarm (red led blinking) ALARM

bonfire_sensor_error:boolean=false;//bonfire sensors error too much different water jacket temperature between two sensors
recuperator_status:string;// status of recuperation, ventilation, air heating
recu_winter:boolean=false;	//recuperator winter/summer mode heat exchanger enabled / disabled
recu_manual_amalva:boolean=true;  //recuperator auto/manual mode for amalva recuperator (auto managed by internal amalva controler, manual by eHouse HeatManager)
went_cooler:boolean=true;       //water cooler on/off for ventilation or recuperation
went_gwc:boolean=false;		//gwc (ground heat exchanger) servomotor on/off
went_aux_gwc_fan:boolean=false;		//auxiliary gwc vetilator / fan on/off for ground heat exchanger
bonfire_dgp:boolean=false;      //bonfire hot air distribution system enabled / disabled
ventilation_on:boolean=false;   //ventilation is currently working on/off
heater_pump:boolean=true;       //pump for heater for ventilation on / off
three_ways_cutoff:integer=0;    //three ways cutoff direction 0 off, 1 increasing level, -1 decreasing level)
solar_pump:boolean=false;	//solar pump on/off
boiler_on:boolean=false;        //boiler enabled / disabled
boiler_pump:boolean=false;	//boiler pump status on/off
boiler_fuel_out:boolean=false;   //boiler out of fuel aproximate (count hours of heating)
boiler_power_on:boolean=false; //boiler power supplay on/off;
boiler_supply_en:boolean=false; //boiler supplay enabled 
boiler_fuel_supply_override:boolean=false; //boiler fuel supplyier override (control by ehouse / internal boiler controller)
bonfire_pump:boolean=false;   //bonfire pump status on/off


heati:array[1..50] of string; //names taken from ehouse.exe HeatManager control panel
firsttime:boolean=true;       //first time execution flag for inicialization
RECU_MODE:integer;           //binary coded recuperation mode from HM
recu_speed:integer=0;     //recuperator speeed 0..3
recu_temperature:integer; //temperature level of recu 0..32
_recu_mode:string='';     //recuperation mode in text as on HEatManager control panel (ehouse.exe)
kom_level:integer=0;    //level for bonfire 0-7 the same as bonfire_stat
kom_stat:integer=0;
        went:string;    //ventilation text status as on HeatManager Control panel (ehouse.exe)
        koci,sola:string; //boiler,solar text status as on HeatManager Control panel (ehouse.exe)
        komi:string; //bonfire text status as on HeatManager Control panel (ehouse.exe)

const   _RECU_WINTER 			=$80;		//winter/summer lato zima 7 bit
        _RECU_MANUAL 			=$40;		//manual - auto bit 6
        _RECU_FULL_AUTO                 =$20;           //recu full auto mode pelna automatyka wentylacji
                                                        //lower bits 0-5 temperature - temperatura 5 lsb 0 do 30
//went mode
        _WENT_CHLODNICA 		=$80;		//cooler pump on for gwc / W³¹czenie chlodnicy w gwc Pompy
        _WENT_GWC			=$40;		//ground heat exchanger for gwc on off/ Wybór Czerpni GWC lub Poludniwej
        _WENT_WENTYLATOR_GWC	        =$20;		//auxiliary ground heat exchanger for gwc / W³¹czenie wentylatora wspomagaj¹cego GWC
        _WENT_DGP                       =$10;           //DGP Fan on/off  / Wl¹czenie wentylatora DGP
        _WENT_UNCONDITIONAL_WENT        =$08;           //Unconditional Ventilation / Bezwarnunkowe wlaczenie wentylacji
        _WENT_CHLODZENIE                =$04;           //Cooling On/ off / chlodzenie

 const  STATUS_ADC		= 1+2;                 //byte indexes in status frame for binary mode - indeksy bajtów z danymi w ramce statusu
        STATUS_OUT  	        =17+2;
        STATUS_IN		=20+2;
        STATUS_INT		=21+2;
        STATUS_OUT25 	        =22+2;
        STATUS_LIGHT	        =23+2;
        STATUS_ZONE_PGM         =26+2;
        STATUS_PROGRAM          =27+2;
        STATUS_INPUTEXT_A_ACTIVE=28+2;
        STATUS_INPUTEXT_B_ACTIVE=32+2;
        STATUS_INPUTEXT_C_ACTIVE=36+2;
        STATUS_INPUTEXT_A 	=40+2;
        STATUS_INPUTEXT_B 	=50+2;
        STATUS_INPUTEXT_C	=60+2;
        STATUS_ADC_HEART		=1+2;
        STATUS_OUT_HEART  	        =33+2;
        STATUS_IN_HEART		        =36+2;
        STATUS_INT_HEART		=37+2;
        STATUS_LOG_HEART		=38+2;		//sumaconst
        STATUS_RAM_SIZE_HEART         =40+2;
        STATUS_ROM_SIZE_HEART         =42+2;		//suma 40
// status commmanagera
 STATUS_EHOUSE1_DEVS		=0;			//miejsce na status urz¹dzeñ pod³¹czonych do RS485
STATUS_ADC_ETH			=72;			//adc pomiary 16 wejœæ * 2B
STATUS_ADC_ETH_END		=STATUS_ADC_ETH+32;	//84	//104
STATUS_OUT_I2C			=STATUS_ADC_ETH_END;   //2 razy i2c razy 10 rej po 8  //max=160 wyjsc	ind 92	//112
STATUS_INPUTS_I2C		=STATUS_OUT_I2C+20;	//2 razy i2c razy 6 rej po 8	//max 96 wejsc	ind 104
STATUS_ALARM_I2C		=STATUS_INPUTS_I2C+12;	//--|---
STATUS_WARNING_I2C		=STATUS_ALARM_I2C+12;		//--|---
STATUS_MONITORING_I2C	        =STATUS_WARNING_I2C+12;	//--|---			//160
STATUS_PROGRAM_NR		=STATUS_MONITORING_I2C+12; //--|---
STATUS_ZONE_NR			=STATUS_PROGRAM_NR+1;
STATUS_ADC_PROGRAM		=STATUS_ZONE_NR+1;
STATUS_LIGHT_LEVEL		=STATUS_ADC_PROGRAM+2;		//3 sciemniacze
														//sciemniacze 3 * 2B

//#define STATUS_INPUTS_I2C_BIS         STATUS_PROGRAM_NR+3+6
//#define STATUS_OUT_I2C_BIS		STATUS_INPUTS_I2C_BIS+6
								//+10B na dodatkowe wyjœcia i2c
//#define STATUS_ADC_PROGRAM		STATUS_OUT_I2C_BIS+10
//#endif
//#define					32+50
STATUS_OUTS_COUNT		=50;	//?????
//#define STATUS_OUTS_BASE  		70		//lokalizacja wyjœæ i2c w statusie informacji 16 bytów
//#define STATUS_INPUTS_BASE		86		//lokalizacja wejœæ i2c w statusie informacji 16 bytów
//#define STATUS_STATUS_AVAILABLE	102		//lokalizacja wolnego obszaru statusu	18B
//#define DelayUsec	DelayUsec


implementation
uses loganalizer,  ExtCtrls, StdCtrls,filectrl,sysutils,
  Windows;//, Messages, Classes, Graphics, Controls, Forms, Dialogs



//calculate temp from lm335 temperature sensor
function gettemplm(dtah,dtal:char;calibration:integer;k:double;VCC:integer):double;
var temp:double;
var t:integer;
//var h:integer;
begin
//t:=ord(dtal);
//h:=ord(dtah);
//t:=t+h*256   ;
t:=ord(dtah)*256+ord(dtal);
temp:=(t*VCC/(1023*k))+calibration/100;
t:=round(temp*10);
temp:=t/10;
result:=temp;
end;
//get absolute adc value 0..1023
/////////////////////////////////////////////////////////////////////////////////////////////////////
function calculate_adc_value(high,low:char):double;
var tmp:integer;
begin
tmp:=ord(high);
tmp:=tmp shl 8;
tmp:=tmp+ord(low);
//tmp:=tmp shr 6;
result:=(tmp*100)/1023;//ADC_QUANT_10;
end;
/////////////////
//get light value in negative scale
/////////////////////////////////////////////////////////////////////////////////////
function getlight(dtah,dtal:char):double;
var
dta:integer;
dtd:double;
begin
dta:=ord(dtah);
dta:=dta shl 8;
dta:=dta+ord(dtal);
dta:=1023-dta;
dtd:=dta*1000;
dta:=round(dtd/1023);
result:=dta/10;
end;
///////////////////////////////////////////////////////////////////////////////////////
//update heatmanager states for RM array
procedure update_hm_temps(index:integer);
var ind:integer;
//temp:double;
begin
ind:=0;
  begin
        RM[index].temp1:=HADC[ind];inc(ind);
        RM[index].temp2:=HADC[ind];inc(ind);
        RM[index].temp3:=HADC[ind];inc(ind);
        RM[index].temp4:=HADC[ind];inc(ind);
        RM[index].temp5:=HADC[ind];inc(ind);
        RM[index].temp6:=HADC[ind];inc(ind);
        RM[index].temp7:=HADC[ind];inc(ind);
        RM[index].temp8:=HADC[ind];inc(ind);
        RM[index].temp9:=HADC[ind];inc(ind);
        RM[index].temp10:=HADC[ind];inc(ind);
        RM[index].temp11:=HADC[ind];inc(ind);
        RM[index].temp12:=HADC[ind];inc(ind);
        RM[index].temp13:=HADC[ind];inc(ind);
        RM[index].temp14:=HADC[ind];inc(ind);
        RM[index].temp15:=HADC[ind];inc(ind);
        RM[index].temp16:=HADC[ind];
  end;
//  inc(ind);
  end;

////////////////////////////////////////////////////////////////////////////////////////
//read heatmanager description fields
procedure get_hm_desc;
var tf:textfile;
i:integer;
begin
if (not fileexists (remotepath+'panels\hm_desc.txt')) then
                        copyfile(Pchar(remotepath+''+inttostr(getuserdefaultLCID)+'.het'),Pchar(remotepath+'panels\hm_desc.txt'),false); //copy file for posibility of changing description for panels
if fileexists(remotepath+'panels\hm_desc.txt') then
        begin
        assignfile(tf,remotepath+'panels\hm_desc.txt');
        reset(tf);
        for i:=1 to 50 do
                begin
                readln(tf,heati[i]);
                end;
        closefile(Tf);
        end

end;
/////////////////////////////////////////////////////////////////////////////////
//set and fill RM array with current data decoded directly from binary status for eHouse1 Controllers
procedure set_rm(str:array of char;        TCP_INDEX_INC:integer);
var     c,tmp:integer;

        dh,dl:integer;
        sms:string;
        tmp1:integer;
        index:integer;
        i,k,l,a,b:integer;
        errors:integer;
        tff:file;
        tf1,tf:textfile;
        count:integer;
        st:string;
        sss:array [0..255] of char;
        statust:string;
        recu_stat:string;
        WENT_MODE,RECU_MODE:integer;
        externalmanageradr:boolean;
        additional:string;
        heartmanager:boolean;
label donotcheck;
begin
{if (firsttime) then
   begin
   get_hm_desc;
   end;
   firsttime:=false;}
additional:='';
heartmanager:=false;
externalmanageradr:=false;
errors:=0;
index:=0;
recu_stat:='';
for k:=0 to ROOMMANAGER_COUNT do
        begin
        if (rm[k].adrh=ord(str[0+TCP_INDEX_INC])) and (rm[k].adrl=ord(str[1+TCP_INDEX_INC])) then
                begin
                rm[k].datetime:=now;
                rm[k].getnewdata:=true;
                end;
        if ((rm[k].adrh=ord(str[0+TCP_INDEX_INC])) and (rm[k].adrl=ord(str[1+TCP_INDEX_INC]))) then
                begin
                index:=k;
                break;
                end;
        if rm[k].devname=null then exit;
        if length(rm[k].devname)<1 then exit;


        end;

heartmanager:=false;
if ((str[0+TCP_INDEX_INC]=chr(1)) and (str[1+TCP_INDEX_INC]=chr(1))) then heartmanager:=true;           //set heatmanager flag from address
if ((str[0+TCP_INDEX_INC]=chr(2)) and (str[1+TCP_INDEX_INC]=chr(1))) then externalmanageradr:=true;     //set externalmanager flag from address - obsolete
TCP_INDEX_INC:=0;
with rm[index] do
begin

end;
st:='';
if (heartmanager) then          //HeatManager
    begin                       //Wentylation, Recuperation, Bonfire and other dedicated status
    WENT_MODE:= ord(str[51+TCP_INDEX_INC]);
    RECU_MODE:= ord(str[50+TCP_INDEX_INC]);
    rm[index].currentprogram:=ord(str[38+TCP_INDEX_INC]);
    b:=RECU_MODE AND $1f;
    c:=WENT_MODE AND 3;
    recu_STAT:=heati[1]+' '+inttostr(ord(c))+', T: '+inttostr(ord(b))+' C, '+heati[2]+' ';
    recu_speed:=c;
    recu_temperature:=b;
    if (RECU_MODE and _RECU_WINTER)     >0	then begin _recu_mode:=heati[3];recu_winter:=true;end
    else 					     begin _recu_mode:=heati[4];recu_winter:=false;end;
    if (RECU_MODE and _RECU_MANUAL)     >0	then begin _recu_mode:=_recu_mode+heati[5];recu_manual_amalva:=true;end
    else 					     begin _recu_mode:=_recu_mode+heati[6];recu_manual_amalva:=false;end;
    recu_stat:=recu_stat+_recu_mode;
    if ((WENT_MODE and _WENT_CHLODNICA)>0 )		then
        begin
        recu_stat:=recu_stat+heati[7];
        went_cooler:=true;
        end
    else
        begin
        went_cooler:=false;
        end;
    if ((WENT_MODE and _WENT_GWC)  >0   )			then
        begin
        went_gwc:=true;
        recu_stat:=recu_stat+heati[9];
        end
    else
        begin
        went_gwc:=false;
        end;
    if ((WENT_MODE and _WENT_WENTYLATOR_GWC)>0)	        then
        begin
        went_aux_gwc_fan:=true;
        recu_stat:=recu_stat+heati[11];
        end
    else
        begin
        went_aux_gwc_fan:=false;
        end;
    if ((WENT_MODE and _WENT_DGP)>0)                        then
        begin
        bonfire_dgp:=true;
        recu_stat:=recu_stat+heati[13];
        end
    else
        begin
        bonfire_dgp:=false;
        end;
    recu_stat:=heati[16]+copy(recu_stat,1,length(recu_Stat)-2);
    b:=  ord(str[49+TCP_INDEX_INC]);
    c:= ord(str[47+TCP_INDEX_INC]);
    went:='';
    komi:='';
    koci:='';
    sola:='';
    if (b and 32)>0 then
        begin
        went:=heati[18];
        ventilation_on:=true;
        end
    else
        begin
        ventilation_on:=false;
        went:=heati[19];
        end;
    if (b and 16)>0 then
                begin
                went:=went+heati[20];
                heater_pump:=true;
                end
    else
                begin
                heater_pump:=false;
                end;
    if (b and 64)>0 then
                begin
                three_ways_cutoff:=1;
                went:=went+' ,+';
                end
    else three_ways_cutoff:=0;
    if (b and 128)>0 then
                begin
                went:=went+' ,-';
                three_ways_cutoff:=-1;
                end;
           if length(went)>0 then statust:=heati[22]+went+recu_stat;
    if (b and 4)>0 then
                begin
                solar_pump:=true;
                sola:=heati[18];
                end
        else
                begin
                solar_pump:=false;
                sola:=heati[19];
                end;
    a:=ord(str[48+TCP_INDEX_INC]);

    if (b and 8)>0 then
                begin
                boiler_on:=true;
                koci:=koci+heati[18];
                end
    else
                begin
                boiler_on:=false;
                koci:=koci+heati[19];
                end;
    if (b and 2)>0 then
                begin
                boiler_pump:=true;
                koci:=koci+heati[26];
                end
    else
                begin
                boiler_pump:=false;
                end;
    if (a and 16)>0 then
                begin
                boiler_fuel_out:=true;
                koci:=koci+heati[27];
                end
    else
                begin
                boiler_fuel_out:=false;
                end;
    if (a and 32)>0 then
                begin
                koci:=koci+' ,!!Alarm!!';
                boiler_alarm:=true;
                end
    else
                begin

                boiler_alarm:=false;
                end;

    if (a and 64)>0 then
                begin
                boiler_power_on:=true;
                koci:=koci+heati[30];
                end
    else
                begin
                boiler_power_on:=false;
                end;
    if (a and 128)>0 then
                begin
                boiler_supply_en:=true;
                koci:=koci+heati[32];
                end
    else
                begin
                boiler_supply_en:=false;
                end;
    if (c and 1)>0 then
                begin
                boiler_fuel_supply_override:=true;
                koci:=koci+heati[34];
                end
    else
                begin
                boiler_fuel_supply_override:=false;
                end;
    if length(koci)>0 then
                statust:=statust+heati[36]+koci;
    a:= (a and $07);
    case a of
        0:   begin komi:=komi+heati[19];bonfire_stat:=0;  end;
        1:   begin komi:=komi+'1';bonfire_stat:=1;end;
        2:   begin komi:=komi+'2';bonfire_stat:=2;end;
        3:   begin komi:=komi+'3';bonfire_stat:=3;end;
        4:   begin komi:=komi+'4';bonfire_stat:=4;end;
        5:   begin komi:=komi+'5';bonfire_stat:=5;end;
        6:   begin komi:=komi+'6';bonfire_stat:=6;end;
        7:   begin komi:=komi+'!!Alarm!!';bonfire_stat:=7;end;
    end;
    kom_level:=a;
    bonfire_pump:=false;
    if (b and 1)>0 then
                begin
                bonfire_pump:=true;
                komi:=komi+heati[37];
                end;
    if (a and 8)>0 then
                begin
                bonfire_sensor_error:=true;
                komi:=komi+heati[38];
                end
    else bonfire_sensor_error:=false;
    if length(komi)>0 then
                begin
                statust:=statust+heati[40]+komi
                end
    else
                begin
                end;
    if length(sola)>0 then  statust:=statust+heati[41]+sola;
    for i:=0 to 15 do                                           //heatManager ADC convertion
        begin
        HADC[i]:=gettemplm(str[STATUS_ADC_HEART+i*2+TCP_INDEX_INC],str[STATUS_ADC_HEART+i*2+1+TCP_INDEX_INC],-27315{rm[index].RCAL1},10,5000);//rm[index].VCC);
        st:=st+floattostr(HADC[i])+chr(9);
        end;
        update_hm_temps(index);
         st:=st+' '+statust;
    //end;
   bonfire_status:=komi;  //status of bonfire for HeatManager
   boiler_status:=koci;   //status of boiler for HM
   Solar_status:=sola;    //status of solar system
   recuperator_status:=went;// status of recuperation, ventilation, air heating
   loganalizer.recuperator_status:=went;
   end
   else                 //other then HeatManager
        begin
        rm[index].currentprogram:=ord(str[STATUS_PROGRAM+TCP_INDEX_INC]);
{       we do not support Input extenders any longer

         if (rm[index].extern) then
                begin
        rm[index].currentzone:=ord(str[STATUS_ZONE_PGM+TCP_INDEX_INC]);
        inextstat[1]:=#0+#0+#0+#0+#0+#0+#0+#0+#0+#0+#0+#0+#0+#0+#0;
        inextstat[2]:=#0+#0+#0+#0+#0+#0+#0+#0+#0+#0+#0+#0+#0+#0+#0;
        inextstat[3]:=#0+#0+#0+#0+#0+#0+#0+#0+#0+#0+#0+#0+#0+#0+#0;
        inextstat[4]:=#0+#0+#0+#0+#0+#0+#0+#0+#0+#0+#0+#0+#0+#0+#0;
        inextstat[5]:=#0+#0+#0+#0+#0+#0+#0+#0+#0+#0+#0+#0+#0+#0+#0;
        inextstat[1]:=str[STATUS_INPUTEXT_A+TCP_INDEX_INC]+str[STATUS_INPUTEXT_A+1+TCP_INDEX_INC]+str[STATUS_INPUTEXT_A+2+TCP_INDEX_INC]+str[STATUS_INPUTEXT_A+3+TCP_INDEX_INC]+str[STATUS_INPUTEXT_A+4+TCP_INDEX_INC]+
                      str[STATUS_INPUTEXT_A+5+TCP_INDEX_INC]+str[STATUS_INPUTEXT_A+6+TCP_INDEX_INC]+str[STATUS_INPUTEXT_A+7+TCP_INDEX_INC]+str[STATUS_INPUTEXT_A+8+TCP_INDEX_INC]+str[STATUS_INPUTEXT_A+9+TCP_INDEX_INC]+
                      str[STATUS_INPUTEXT_A_ACTIVE+TCP_INDEX_INC]+str[STATUS_INPUTEXT_A_ACTIVE+1+TCP_INDEX_INC]+str[STATUS_INPUTEXT_A_ACTIVE+2+TCP_INDEX_INC]+str[STATUS_INPUTEXT_A_ACTIVE+3+TCP_INDEX_INC];
        inextstat[2]:=str[STATUS_INPUTEXT_B+TCP_INDEX_INC]+str[STATUS_INPUTEXT_B+1+TCP_INDEX_INC]+str[STATUS_INPUTEXT_B+2+TCP_INDEX_INC]+str[STATUS_INPUTEXT_B+3+TCP_INDEX_INC]+str[STATUS_INPUTEXT_B+4+TCP_INDEX_INC]+
                      str[STATUS_INPUTEXT_B+5+TCP_INDEX_INC]+str[STATUS_INPUTEXT_B+6+TCP_INDEX_INC]+str[STATUS_INPUTEXT_B+7+TCP_INDEX_INC]+str[STATUS_INPUTEXT_B+8+TCP_INDEX_INC]+str[STATUS_INPUTEXT_B+9+TCP_INDEX_INC]+
                      str[STATUS_INPUTEXT_B_ACTIVE+TCP_INDEX_INC]+str[STATUS_INPUTEXT_B_ACTIVE+1+TCP_INDEX_INC]+str[STATUS_INPUTEXT_B_ACTIVE+2+TCP_INDEX_INC]+str[STATUS_INPUTEXT_B_ACTIVE+3+TCP_INDEX_INC];
        inextstat[3]:=str[STATUS_INPUTEXT_C+TCP_INDEX_INC]+str[STATUS_INPUTEXT_C+1+TCP_INDEX_INC]+str[STATUS_INPUTEXT_C+2+TCP_INDEX_INC]+str[STATUS_INPUTEXT_C+3+TCP_INDEX_INC]+str[STATUS_INPUTEXT_C+4+TCP_INDEX_INC]+
                      str[STATUS_INPUTEXT_C+5+TCP_INDEX_INC]+str[STATUS_INPUTEXT_C+6+TCP_INDEX_INC]+str[STATUS_INPUTEXT_C+7+TCP_INDEX_INC]+str[STATUS_INPUTEXT_C+8+TCP_INDEX_INC]+str[STATUS_INPUTEXT_C+9+TCP_INDEX_INC]+
                      str[STATUS_INPUTEXT_c_ACTIVE+TCP_INDEX_INC]+str[STATUS_INPUTEXT_c_ACTIVE+1+TCP_INDEX_INC]+str[STATUS_INPUTEXT_C_ACTIVE+2+TCP_INDEX_INC]+str[STATUS_INPUTEXT_C_ACTIVE+3+TCP_INDEX_INC];
        saveinex;
               end;}
        rm[index].adc1:=calculate_adc_value(str[STATUS_ADC+TCP_INDEX_INC],str[STATUS_ADC+1+TCP_INDEX_INC]);
        rm[index].adc2:=calculate_adc_value(str[STATUS_ADC+2+TCP_INDEX_INC],str[STATUS_ADC+3+TCP_INDEX_INC]);
        rm[index].adc3:=calculate_adc_value(str[STATUS_ADC+4+TCP_INDEX_INC],str[STATUS_ADC+5+TCP_INDEX_INC]);
        rm[index].adc4:=calculate_adc_value(str[STATUS_ADC+6+TCP_INDEX_INC],str[STATUS_ADC+7+TCP_INDEX_INC]);
        rm[index].adc5:=calculate_adc_value(str[STATUS_ADC+8+TCP_INDEX_INC],str[STATUS_ADC+9+TCP_INDEX_INC]);
        rm[index].adc6:=calculate_adc_value(str[STATUS_ADC+10+TCP_INDEX_INC],str[STATUS_ADC+11+TCP_INDEX_INC]);
        rm[index].adc7:=calculate_adc_value(str[STATUS_ADC+12+TCP_INDEX_INC],str[STATUS_ADC+13+TCP_INDEX_INC]);
        rm[index].adc8:=calculate_adc_value(str[STATUS_ADC+14+TCP_INDEX_INC],str[STATUS_ADC+15+TCP_INDEX_INC]);
        rm[index].LIGHT1:=getlight(str[STATUS_ADC+TCP_INDEX_INC],str[STATUS_ADC+1+TCP_INDEX_INC]);
        rm[index].LIGHT2:=getlight(str[STATUS_ADC+2+TCP_INDEX_INC],str[STATUS_ADC+3+TCP_INDEX_INC]);
        rm[index].LIGHT3:=getlight(str[STATUS_ADC+4+TCP_INDEX_INC],str[STATUS_ADC+5+TCP_INDEX_INC]);
        rm[index].LIGHT4:=getlight(str[STATUS_ADC+6+TCP_INDEX_INC],str[STATUS_ADC+7+TCP_INDEX_INC]);
        rm[index].LIGHT5:=getlight(str[STATUS_ADC+8+TCP_INDEX_INC],str[STATUS_ADC+9+TCP_INDEX_INC]);
        rm[index].LIGHT6:=getlight(str[STATUS_ADC+10+TCP_INDEX_INC],str[STATUS_ADC+11+TCP_INDEX_INC]);
        rm[index].LIGHT7:=getlight(str[STATUS_ADC+12+TCP_INDEX_INC],str[STATUS_ADC+13+TCP_INDEX_INC]);
        rm[index].LIGHT8:=getlight(str[STATUS_ADC+14+TCP_INDEX_INC],str[STATUS_ADC+15+TCP_INDEX_INC]);



        rm[index].TEMP1:=gettemplm(str[STATUS_ADC+0+TCP_INDEX_INC],str[STATUS_ADC+1+TCP_INDEX_INC],-27315,10,5000);//rm[index].RCAL1,10,rm[index].VCC);
        rm[index].TEMP2:=gettemplm(str[STATUS_ADC+2+TCP_INDEX_INC],str[STATUS_ADC+3+TCP_INDEX_INC],-27315,10,5000);//rm[index].RCAL2,10,rm[index].VCC);
        rm[index].TEMP3:=gettemplm(str[STATUS_ADC+4+TCP_INDEX_INC],str[STATUS_ADC+5+TCP_INDEX_INC],-27315,10,5000);//rm[index].RCAL3,10,rm[index].VCC);
        rm[index].TEMP4:=gettemplm(str[STATUS_ADC+6+TCP_INDEX_INC],str[STATUS_ADC+7+TCP_INDEX_INC],-27315,10,5000);//rm[index].RCAL4,10,rm[index].VCC);
        rm[index].TEMP5:=gettemplm(str[STATUS_ADC+8+TCP_INDEX_INC],str[STATUS_ADC+9+TCP_INDEX_INC],-27315,10,5000);//rm[index].RCAL5,10,rm[index].VCC);
        rm[index].TEMP6:=gettemplm(str[STATUS_ADC+10+TCP_INDEX_INC],str[STATUS_ADC+11+TCP_INDEX_INC],-27315,10,5000);//rm[index].RCAL6,10,rm[index].VCC);
        rm[index].TEMP7:=gettemplm(str[STATUS_ADC+12+TCP_INDEX_INC],str[STATUS_ADC+13+TCP_INDEX_INC],-27315,10,5000);//rm[index].RCAL7,10,rm[index].VCC);
        rm[index].TEMP8:=gettemplm(str[STATUS_ADC+14+TCP_INDEX_INC],str[STATUS_ADC+15+TCP_INDEX_INC],-27315,10,5000);//rm[index].RCAL8,10,rm[index].VCC);

        end;


rm[index].adc1:=calculate_adc_value(str[STATUS_ADC+TCP_INDEX_INC],str[STATUS_ADC+1+TCP_INDEX_INC]);
rm[index].adc2:=calculate_adc_value(str[STATUS_ADC+2+TCP_INDEX_INC],str[STATUS_ADC+3+TCP_INDEX_INC]);
rm[index].adc3:=calculate_adc_value(str[STATUS_ADC+4+TCP_INDEX_INC],str[STATUS_ADC+5+TCP_INDEX_INC]);
rm[index].adc4:=calculate_adc_value(str[STATUS_ADC+6+TCP_INDEX_INC],str[STATUS_ADC+7+TCP_INDEX_INC]);
rm[index].adc5:=calculate_adc_value(str[STATUS_ADC+8+TCP_INDEX_INC],str[STATUS_ADC+9+TCP_INDEX_INC]);
rm[index].adc6:=calculate_adc_value(str[STATUS_ADC+10+TCP_INDEX_INC],str[STATUS_ADC+11+TCP_INDEX_INC]);
rm[index].adc7:=calculate_adc_value(str[STATUS_ADC+12+TCP_INDEX_INC],str[STATUS_ADC+13+TCP_INDEX_INC]);
rm[index].adc8:=calculate_adc_value(str[STATUS_ADC+14+TCP_INDEX_INC],str[STATUS_ADC+15+TCP_INDEX_INC]);
//do not use calibration
rm[index].TEMP1:=gettemplm(str[STATUS_ADC+0+TCP_INDEX_INC],str[STATUS_ADC+1+TCP_INDEX_INC],-27315,10,5000);//rm[index].RCAL1,10,rm[index].VCC);
rm[index].TEMP2:=gettemplm(str[STATUS_ADC+2+TCP_INDEX_INC],str[STATUS_ADC+3+TCP_INDEX_INC],-27315,10,5000);//rm[index].RCAL2,10,rm[index].VCC);
rm[index].TEMP3:=gettemplm(str[STATUS_ADC+4+TCP_INDEX_INC],str[STATUS_ADC+5+TCP_INDEX_INC],-27315,10,5000);//rm[index].RCAL3,10,rm[index].VCC);
rm[index].TEMP4:=gettemplm(str[STATUS_ADC+6+TCP_INDEX_INC],str[STATUS_ADC+7+TCP_INDEX_INC],-27315,10,5000);//rm[index].RCAL4,10,rm[index].VCC);
rm[index].TEMP5:=gettemplm(str[STATUS_ADC+8+TCP_INDEX_INC],str[STATUS_ADC+9+TCP_INDEX_INC],-27315,10,5000);//rm[index].RCAL5,10,rm[index].VCC);
rm[index].TEMP6:=gettemplm(str[STATUS_ADC+10+TCP_INDEX_INC],str[STATUS_ADC+11+TCP_INDEX_INC],-27315,10,5000);//rm[index].RCAL6,10,rm[index].VCC);
rm[index].TEMP7:=gettemplm(str[STATUS_ADC+12+TCP_INDEX_INC],str[STATUS_ADC+13+TCP_INDEX_INC],-27315,10,5000);//rm[index].RCAL7,10,rm[index].VCC);
rm[index].TEMP8:=gettemplm(str[STATUS_ADC+14+TCP_INDEX_INC],str[STATUS_ADC+15+TCP_INDEX_INC],-27315,10,5000);//rm[index].RCAL8,10,rm[index].VCC);

rm[index].LIGHT1:=getlight(str[STATUS_ADC+TCP_INDEX_INC],str[STATUS_ADC+1+TCP_INDEX_INC]);

rm[index].LIGHT2:=getlight(str[STATUS_ADC+2+TCP_INDEX_INC],str[STATUS_ADC+3+TCP_INDEX_INC]);
rm[index].LIGHT3:=getlight(str[STATUS_ADC+4+TCP_INDEX_INC],str[STATUS_ADC+5+TCP_INDEX_INC]);
rm[index].LIGHT4:=getlight(str[STATUS_ADC+6+TCP_INDEX_INC],str[STATUS_ADC+7+TCP_INDEX_INC]);
rm[index].LIGHT5:=getlight(str[STATUS_ADC+8+TCP_INDEX_INC],str[STATUS_ADC+9+TCP_INDEX_INC]);
rm[index].LIGHT6:=getlight(str[STATUS_ADC+10+TCP_INDEX_INC],str[STATUS_ADC+11+TCP_INDEX_INC]);
rm[index].LIGHT7:=getlight(str[STATUS_ADC+12+TCP_INDEX_INC],str[STATUS_ADC+13+TCP_INDEX_INC]);
rm[index].LIGHT8:=getlight(str[STATUS_ADC+14+TCP_INDEX_INC],str[STATUS_ADC+15+TCP_INDEX_INC]);




if not heartmanager then
        begin
        tmp:=ord(str[STATUS_OUT+2+TCP_INDEX_INC]);
        tmp:=tmp shl 16;
        tmp1:=ord(str[STATUS_OUT+1+TCP_INDEX_INC]);
        tmp1:=tmp1 shl 8;
        tmp:=tmp+tmp1+ord(str[STATUS_OUT+TCP_INDEX_INC]);
        end
else
        begin
        tmp:=ord(str[STATUS_OUT_HEART+2+TCP_INDEX_INC]);
        tmp:=tmp shl 16;
        tmp1:=ord(str[STATUS_OUT_HEART+1+TCP_INDEX_INC]);
        tmp1:=tmp1 shl 8;
        tmp:=tmp+tmp1+ord(str[STATUS_OUT_HEART+TCP_INDEX_INC]);
        rm[index].currentprogram:=ord(str[STATUS_OUT_HEART+4+TCP_INDEX_INC]);
        end;
begin

begin                                   //set output states from binary data
if ( (tmp and 1)>0)             then    begin rm[index].out1:=true;end
                                else    begin rm[index].out1:=false;end;
if ( (tmp and 2)>0)             then    begin rm[index].out2:=true;end
                                else    begin rm[index].out2:=false;end;
if ( (tmp and 4)>0)             then    begin rm[index].out3:=true;end
                                else    begin rm[index].out3:=false;end;
if ( (tmp and 8)>0)             then    begin rm[index].out4:=true;end
                                else    begin rm[index].out4:=false;end;
if ( (tmp and 16)>0)            then    begin rm[index].out5:=true;end
                                else    begin rm[index].out5:=false;end;
if ( (tmp and 32)>0)            then    begin rm[index].out6:=true;end
                                else    begin rm[index].out6:=false;end;
if ( (tmp and 64)>0)            then    begin rm[index].out7:=true;end
                                else    begin rm[index].out7:=false;end;
if ( (tmp and 128)>0)           then    begin rm[index].out8:=true;end
                                else    begin rm[index].out8:=false;end;
if ( (tmp and 256)>0)           then    begin rm[index].out9:=true;end
                                else    begin rm[index].out9:=false;end;
if ( (tmp and 512)>0)           then    begin rm[index].out10:=true;end
                                else    begin rm[index].out10:=false;end;
if ( (tmp and 1024)>0)          then    begin rm[index].out11:=true;end
                                else    begin rm[index].out11:=false;end;
if ( (tmp and 2048)>0)          then    begin rm[index].out12:=true;end
                                else    begin rm[index].out12:=false;end;
if ( (tmp and 4096)>0)          then    begin rm[index].out13:=true;end
                                else    begin rm[index].out13:=false;end;
if ( (tmp and 8192)>0)          then    begin rm[index].out14:=true;end
                                else    begin rm[index].out14:=false;end;
if ( (tmp and 16384)>0)         then    begin rm[index].out15:=true;end
                                else    begin rm[index].out15:=false;end;
if ( (tmp and 32768)>0)         then    begin rm[index].out16:=true;end
                                else    begin rm[index].out16:=false;end;
if ( (tmp and 65536)>0)         then    begin rm[index].out17:=true;end
                                else    begin rm[index].out17:=false;end;
if ( (tmp and 131072)>0)        then    begin rm[index].out18:=true;end
                                else    begin rm[index].out18:=false;end;
if ( (tmp and 262144)>0)        then    begin rm[index].out19:=true;end
                                else    begin rm[index].out19:=false;end;
if ( (tmp and 524288)>0)        then    begin rm[index].out20:=true;end
                                else    begin rm[index].out20:=false;end;
if ( (tmp and 1048576)>0)       then    begin rm[index].out21:=true;end
                                else    begin rm[index].out21:=false;end;
if ( (tmp and 2097152)>0)       then    begin rm[index].out22:=true;end
                                else    begin rm[index].out22:=false;end;
if ( (tmp and 4194304)>0)       then    begin rm[index].out23:=true;end
                                else    begin rm[index].out23:=false;end;
if ( (tmp and 8388608)>0)       then    begin rm[index].out24:=true;end
                                else    begin rm[index].out24:=false;end;
tmp:=ord(str[STATUS_OUT25]);
if ( (tmp and 1)>0)             then    begin rm[index].out25:=true; end
                                else    begin rm[index].out25:=false;end;
if ( (tmp and 2)>0)             then    begin rm[index].out26:=true;end
                                else    begin rm[index].out26:=false;end;
if ( (tmp and 4)>0)             then    begin rm[index].out27:=true;end
                                else    begin rm[index].out27:=false;end;
if ( (tmp and 8)>0)             then    begin rm[index].out28:=true;end
                                else    begin rm[index].out28:=false;end;
if ( (tmp and 16)>0)            then    begin rm[index].out29:=true;end
                                else    begin rm[index].out29:=false;end;
if ( (tmp and 32)>0)            then    begin rm[index].out30:=true;end
                                else    begin rm[index].out30:=false;end;
if ( (tmp and 64)>0)            then    begin rm[index].out31:=true;end
                                else    begin rm[index].out31:=false;end;
if ( (tmp and 128)>0)           then    begin rm[index].out32:=true;end
                                else    begin rm[index].out32:=false;end;

end    ;
if (not heartmanager) then
begin
tmp:=ord(str[STATUS_INT+TCP_INDEX_INC]);        //set input states from binary data
if ( (tmp and 1)>0)             then    begin rm[index].int1:=true  ;end
                                else    begin rm[index].int1:=false;end;
if ( (tmp and 2)>0)             then    begin rm[index].int2:=true   ;end
                                else    begin rm[index].int2:=false;end;
if ( (tmp and 4)>0)             then    begin rm[index].int3:=true    ;end
                                else    begin rm[index].int3:=false;end;
if ( (tmp and 8)>0)             then    begin rm[index].int4:=true    ;end
                                else    begin rm[index].int4:=false;end;
if ( (tmp and 16)>0)            then    begin rm[index].int5:=true    ;end
                                else    begin rm[index].int5:=false;end;
if ( (tmp and 32)>0)            then    begin rm[index].int6:=true ; end
                                else    begin rm[index].int6:=false;end;
if ( (tmp and 64)>0)            then    begin rm[index].int7:=true    ;end
                                else    begin rm[index].int7:=false;end;
if ( (tmp and 128)>0)           then    begin rm[index].int8:=true    ;end
                                else    begin rm[index].int8:=false;end;

tmp:=ord(str[STATUS_IN]);               //set input part 2 states from binary data
if ( (tmp and 1)>0)             then    begin rm[index].in1:=true   ; end
                                else    begin rm[index].in1:=false;  end;
if ( (tmp and 2)>0)             then    begin rm[index].in2:=true   ; end
                                else    begin rm[index].in2:=false;  ;end;
if ( (tmp and 4)>0)             then    begin rm[index].in3:=true    ;end
                                else    begin rm[index].in3:=false;  ;end;
if ( (tmp and 8)>0)             then    begin rm[index].in4:=true    ;end
                                else    begin rm[index].in4:=false;  ;end;
if ( (tmp and 16)>0)            then    begin rm[index].in5:=true    ;end
                                else    begin rm[index].in5:=false;  ;end;
if ( (tmp and 32)>0)            then    begin rm[index].in6:=true    ;end
                                else    begin rm[index].in6:=false;  ;end;
if ( (tmp and 64)>0)            then    begin rm[index].in7:=true    ;end
                                else    begin rm[index].in7:=false;  ;end;
if ( (tmp and 128)>0)           then    begin rm[index].in8:=true    ;end
                                else    begin rm[index].in8:=false;  ;end;

end;
end;
{Input extenders not supported any longer
if (rm[index].extern) then
        begin
        sms:=getalarmstate(1);
        sms:=sms+getalarmstate(2);
        sms:=sms+getalarmstate(3);

        if length(sms)>0 then
                begin
                writeln(tf,'Alarm: '+sms);
                communication.admem('SECU: '+sms);
                if alarmextender>0 then
                        begin
                        wasalarm:=true;
                        for i:=0 to smsreports.Count-1 do
                                begin
                                createsms(smsreports.strings[i],'Alarm: '+sms);
                                end;
                        end;
                for i:=0 to smsadmins.Count-1 do
                        begin
                        createsms(smsadmins.strings[i],'Alarm: '+sms);
                        end;
                end;
        end;
        }
   k:=1;

end;
////////////////////////////////////////////////////////////////////////////////
// set status of CommManager attached to eHouse1 controllers status
// or explicit i pure Ethernet Ehouse Version
procedure set_status_commmanager(statusb:array of char);
var str:string;
m,k,l,i:integer;
offset:integer;
Alarms:string;
Warnings:string;
monitorings:string;
Actives:string;
Outputs:string;
ADCS:string;
rm:boolean;
begin
rm:=false;
//if statusb[1]=#0 then exit;      //comm manager status of e-house 1 was send first
                                // if not commmanager then exit

if ((statusb[1]>#0) and (statusb[1]<#100) and (statusb[2]<#100)) then rm:=true;      //Ehouse1 controllers Manager status  //device address high 1-100

//if (statusb[2]>
if ( (not rm) and (statusb[2]<#240)) then exit;      //EthernetEhouseManager status  if device adress low >= 240 also commmanager explicit
//if (statusb[3]<>'s') then exit;
ethrm[commmanagerindex].getnewdata:=true;               //set new data capture flag

ethrm[commmanagerindex].datetime:=now;                  //set data capture for info


offset:=0;
for i:=0 to 15 do       //przetworniki - ADCs
        begin
        ethrm[commmanagerindex].adcs[i]:=calculate_adc_value(statusb[STATUS_ADC_ETH+offset+i*2] ,statusb[STATUS_ADC_ETH+offset+i*2+1]);
        ethrm[commmanagerindex].adcsind[i]:=calcindex(statusb[STATUS_ADC_ETH+offset+i*2] ,statusb[STATUS_ADC_ETH+offset+i*2+1]);
        ethrm[commmanagerindex].temps[i]:=gettemplm(statusb[STATUS_ADC_ETH+offset+i*2] ,statusb[STATUS_ADC_ETH+offset+i*2+1],-27315{rm[index].RCAL1},10,3300);
        ethrm[commmanagerindex].tempsMCP9701[i]:=calculate_MCP9701(ethrm[commmanagerindex].adcsind[i],ethrm[commmanagerindex].VCC,ethrm[commmanagerindex].MCP9701_Offset,ethrm[commmanagerindex].MCP9701x);
        ethrm[commmanagerindex].tempsMCP9700[i]:=calculate_MCP9700(ethrm[commmanagerindex].adcsind[i],ethrm[commmanagerindex].VCC,ethrm[commmanagerindex].MCP9700_Offset,ethrm[commmanagerindex].MCP9700x);

        end;

offset:=0;
for m:=0 to 19 do         //bajty                                                //wyjscia i2c 20 bytow * 8 max 160 wyjsc
        for i:=0 to 7 do //bity                                                 //i2c outputs max 160 outputs
                begin
                if ((ord(statusb[STATUS_OUT_I2C+offset+m]) and (1 shl i))>0)   then     //wlaczone wyjscie   / output on
                        begin
                        ethrm[commmanagerindex].xdouts[m*8+i]:=true;
                        end
                else
                        begin
                        ethrm[commmanagerindex].xdouts[m*8+i]:=false;
                        end;
                end;

offset:=0;
for m:=0 to 11 do         //bajty                                                //wejscia i2c zwykle max 96    // i2c digital inputs max 96
        for i:=0 to 7 do //bity
                begin
                if ((ord(statusb[STATUS_INPUTS_I2C+offset+m]) and (1 shl i))>0) then
                        begin
                        ethrm[commmanagerindex].xdins[m*8+i]:=true;
                        end
                else
                        ethrm[commmanagerindex].xdins[m*8+i]:=false;

                if ((ord(statusb[STATUS_ALARM_I2C+offset+m]) and (1 shl i))>0) then
                        begin
                        ethrm[commmanagerindex].xalarms[m*8+i]:=true;
                        end
                else ethrm[commmanagerindex].xalarms[m*8+i]:=false;

                if ((ord(statusb[STATUS_WARNING_I2C+offset+m]) and (1 shl i))>0) then
                        begin
                        ethrm[commmanagerindex].xwarnings[m*8+i]:=true;
                        end
                else ethrm[commmanagerindex].xwarnings[m*8+i]:=false;

                if ((ord(statusb[STATUS_MONITORING_I2C+offset+m]) and (1 shl i))>0) then
                        begin
                        ethrm[commmanagerindex].xmonitorings[m*8+i]:=true;
                        end
                else
                        ethrm[commmanagerindex].xmonitorings[m*8+i]:=false;





                end;
//set important information for cm: Current Zone, Current Program, Zone Name, Program Name, ADC program, AdC Programname
ethrm[commmanagerindex].currentprogram:=ord(statusb[STATUS_PROGRAM_NR]);

ethrm[commmanagerindex].currentzone:=ord(statusb[STATUS_ZONE_NR]);
ethrm[commmanagerindex].currentadcprogram:=ord(statusb[STATUS_ADC_PROGRAM]);
if ethrm[commmanagerindex].currentprogram<XPROGRAMS_COUNT then
        ethrm[commmanagerindex].currentprogramname:=ethrm[commmanagerindex].programsnames[ethrm[commmanagerindex].currentprogram];
if ethrm[commmanagerindex].currentzone<XZONES_COUNT then
        ethrm[commmanagerindex].currentzonename:=ethrm[commmanagerindex].zonenames[ethrm[commmanagerindex].currentzone];
if ethrm[commmanagerindex].currentadcprogram<XADC_PROGRAMS_COUNT then
        ethrm[commmanagerindex].currentadcprogramname:=ethrm[commmanagerindex].adcprogramsnames[ethrm[commmanagerindex].currentadcprogram];




end;
////////////////////////////////////////////////////////////////////////////////////
//
// Perform status of other ethernet controllers than CommManager
//
///////////////////////////////////////////////////////////////////////////////////
procedure set_status_ethroommanager(statusb:array of char);
var str:string;
m,k,l,i:integer;
offset:integer;
Alarms:string;
Warnings:string;
monitorings:string;
Actives:string;
Outputs:string;
ADCS:string;
ethroommanagerindex:integer;

begin
ethroommanagerindex:=-1;
//if ((statusb[1]>#0) and (statusb[1]<#100)) then exit;      //RoomManagers via commmanager status reserved
if ((statusb[2]<#100)) then exit;
if (statusb[2]>=#250) then exit;        //commmanager exclusive status reserved
if (statusb[3]<>'s') then exit;         //only status data perform

for i:=0 to ethernetdevscount do
        begin
        if ((ethrm[i].adrh=ord(statusb[1])) and (ethrm[i].adrl=ord(statusb[2]))) then
                begin
                ethroommanagerindex:=i;
                break;
                end;

        end;

if ethroommanagerindex<0 then exit;
//if commManagerIndex=ethroommanagerindex then exit;
ethrm[ethroommanagerindex].getnewdata:=true;
ethrm[ethroommanagerindex].datetime:=now;

offset:=0;

for i:=0 to 15 do       //przetworniki
        begin
        ethrm[ethroommanagerindex].adcs[i]:=calculate_adc_value(statusb[STATUS_ADC_ETH+offset+i*2] ,statusb[STATUS_ADC_ETH+offset+i*2+1]);
        ethrm[ethroommanagerindex].adcsind[i]:=calcindex(statusb[STATUS_ADC_ETH+offset+i*2] ,statusb[STATUS_ADC_ETH+offset+i*2+1]);
        ethrm[ethroommanagerindex].temps[i]:=gettemplm(statusb[STATUS_ADC_ETH+offset+i*2] ,statusb[STATUS_ADC_ETH+offset+i*2+1],-27315{rm[index].RCAL1},10,3300);
        ethrm[ethroommanagerindex].tempsMCP9701[i]:=calculate_MCP9701(ethrm[ethroommanagerindex].adcsind[i],ethrm[ethroommanagerindex].VCC,ethrm[ethroommanagerindex].MCP9701_Offset,ethrm[ethroommanagerindex].MCP9701x);
        ethrm[ethroommanagerindex].tempsMCP9700[i]:=calculate_MCP9700(ethrm[ethroommanagerindex].adcsind[i],ethrm[ethroommanagerindex].VCC,ethrm[ethroommanagerindex].MCP9700_Offset,ethrm[ethroommanagerindex].MCP9700x);


 //      if pos('@',ethrm[ethroommanagerindex].adcsnames[i])=0 then
//                ADCS:=ADCS+#9+ethrm[ethroommanagerindex].adcsnames[i]+':'+#9+GetStringValue(ethroommanagerindex,ethrm[ethroommanagerindex].adcsind[i],i)+eoln;
        end;

offset:=0;

for m:=0 to 20 do         //bajty                                                //normal digital outputs
        for i:=0 to 7 do //bity
                begin
                if ((ord(statusb[STATUS_OUT_I2C+offset+m]) and (1 shl i))>0)   then     //wlaczone wyjscie
                        begin
//                        Outputs:=Outputs+#9+ethrm[ethroommanagerindex].xdoutsnames[m*8+i]+eoln;
                        ethrm[ethroommanagerindex].xdouts[m*8+i]:=true;
                        end
                else
                        begin
                        ethrm[ethroommanagerindex].xdouts[m*8+i]:=false;
                        end;
                end;

//                end;
offset:=0;
for m:=0 to 11 do         //bajty                                                //normal digital inputs
        for i:=0 to 7 do //bity
                begin
                if ((ord(statusb[STATUS_INPUTS_I2C+offset+m]) and (1 shl i))>0) then
                        begin
                        ethrm[ethroommanagerindex].xdins[m*8+i]:=true;
                        end
                else
                        ethrm[ethroommanagerindex].xdins[m*8+i]:=false;

                if ((ord(statusb[STATUS_ALARM_I2C+offset+m]) and (1 shl i))>0) then
                        begin
                        ethrm[ethroommanagerindex].xalarms[m*8+i]:=true;
                        end
                else
                        ethrm[ethroommanagerindex].xalarms[m*8+i]:=false;

                if ((ord(statusb[STATUS_WARNING_I2C+offset+m]) and (1 shl i))>0) then
                        begin
                        ethrm[ethroommanagerindex].xwarnings[m*8+i]:=true;
                        end
                else
                        ethrm[ethroommanagerindex].xwarnings[m*8+i]:=false;

                if ((ord(statusb[STATUS_MONITORING_I2C+offset+m]) and (1 shl i))>0) then
                        begin
                        ethrm[ethroommanagerindex].xmonitorings[m*8+i]:=true;
                        end
                else
                        ethrm[ethroommanagerindex].xmonitorings[m*8+i]:=false;

                end;
//set some important information as program, adc program, program name, adc program name
ethrm[ethroommanagerindex].currentprogram:=ord(statusb[STATUS_PROGRAM_NR]);
ethrm[ethroommanagerindex].currentzone:=ord(statusb[STATUS_ZONE_NR]);
ethrm[ethroommanagerindex].currentadcprogram:=ord(statusb[STATUS_ADC_PROGRAM]);
if ethrm[ethroommanagerindex].currentprogram<XPROGRAMS_COUNT then
        ethrm[ethroommanagerindex].currentprogramname:=ethrm[ethroommanagerindex].programsnames[ethrm[ethroommanagerindex].currentprogram];
if ethrm[ethroommanagerindex].currentzone<XZONES_COUNT then
        ethrm[ethroommanagerindex].currentzonename:=ethrm[ethroommanagerindex].zonenames[ethrm[ethroommanagerindex].currentzone];
if ethrm[ethroommanagerindex].currentadcprogram<XADC_PROGRAMS_COUNT then
        ethrm[ethroommanagerindex].currentadcprogramname:=ethrm[ethroommanagerindex].adcprogramsnames[ethrm[ethroommanagerindex].currentadcprogram];

end;



//////////////////////////////////////////////////////////////////////////////////

function calcindex(high,low:char):integer;
begin
result:=ord(high) shl 8;
result:=result+ord(low);
end;



end.
