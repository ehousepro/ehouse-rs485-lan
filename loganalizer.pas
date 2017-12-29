unit loganalizer;
{
Author : Robert Jarzabek
http://www.iSys.Pl/
http://inteligentny-dom.ehouse.pro/
http://www.eHouse.Pro/

This source code loacation:   http://www.iSys.Pl/download/delphi/

eHouse System Controller Status analizer
One Controller Panel PC software
capture data from eHouse controllers via UDP
load and synchronize status to local software cache matrix
display status of desired controller on panel RM, ERM, HM
Buttons are active and store events to email directory
can be template of any eHouse management application
        control panel,
        communication server,
        gateway,
        log analizer
        etc

implemented tcp client for direct sending events in case of Ethernet ehouse version
        or ehouse1 under CommManager supervision

in case of old ehouse1 version place "%ehouseDir%\ehouse1.cfg" file
otherwise it will create events files in email directory instead of sending via TCP/IP

Verified for version as of date 20121201

Known issues
no status for CommManager
no status for LevelManager
Cant run multiple UDP listener on the same machine - do not refresh data on every application
No Inputs states
Text can be too large for image buttons and labels can overlap
No null dev support do not inform



}
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls,filectrl, Buttons, NMUDP, ScktComp, ComCtrls;

type
  TForm1 = class(TForm)
    Timer1: TTimer;
    output1: TPanel;
    output2: TPanel;
    output3: TPanel;
    output4: TPanel;
    output5: TPanel;
    output6: TPanel;
    output7: TPanel;
    output8: TPanel;
    output9: TPanel;
    output10: TPanel;
    output11: TPanel;
    output12: TPanel;
    output13: TPanel;
    output14: TPanel;
    output15: TPanel;
    output16: TPanel;
    output17: TPanel;
    output18: TPanel;
    output19: TPanel;
    output20: TPanel;
    output21: TPanel;
    output22: TPanel;
    output23: TPanel;
    output24: TPanel;
    Program1: TPanel;
    Program2: TPanel;
    Program3: TPanel;
    Program4: TPanel;
    Program5: TPanel;
    Program6: TPanel;
    Program7: TPanel;
    Program8: TPanel;
    Program9: TPanel;
    Program10: TPanel;
    Program11: TPanel;
    Program12: TPanel;
    Program13: TPanel;
    Program14: TPanel;
    Program15: TPanel;
    Program16: TPanel;
    Program17: TPanel;
    Program18: TPanel;
    Program19: TPanel;
    Program20: TPanel;
    Program21: TPanel;
    Program22: TPanel;
    Program23: TPanel;
    Program24: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    NMUDP1: TNMUDP;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    binary: TNMUDP;
    ADCProgram1: TPanel;
    ADCProgram2: TPanel;
    ADCProgram3: TPanel;
    ADCProgram4: TPanel;
    ADCProgram5: TPanel;
    ADCProgram6: TPanel;
    ADCProgram7: TPanel;
    ADCProgram8: TPanel;
    ADCProgram9: TPanel;
    ADCProgram10: TPanel;
    ADCProgram11: TPanel;
    ADCProgram12: TPanel;
    ADCProgram13: TPanel;
    ADCProgram14: TPanel;
    ADCProgram15: TPanel;
    ADCProgram16: TPanel;
    ADCProgram17: TPanel;
    ADCProgram18: TPanel;
    ADCProgram19: TPanel;
    ADCProgram20: TPanel;
    ADCProgram21: TPanel;
    ADCProgram22: TPanel;
    ADCProgram23: TPanel;
    ADCProgram24: TPanel;
    berkeley: TClientSocket;
    Panel1: TPanel;
    DeviceList: TTabControl;
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Program1Click(Sender: TObject);
    procedure output1Click(Sender: TObject);
    procedure NMUDP1DataReceived(Sender: TComponent; NumberBytes: Integer;
      FromIP: String; Port: Integer);
    procedure binaryDataReceived(Sender: TComponent; NumberBytes: Integer;
      FromIP: String; Port: Integer);
    procedure ADCProgram1Click(Sender: TObject);
    procedure berkeleyDisconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure berkeleyRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure berkeleyError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure berkeleyConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure berkeleyConnecting(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure berkeleyLookup(Sender: TObject; Socket: TCustomWinSocket);
    procedure berkeleyWrite(Sender: TObject; Socket: TCustomWinSocket);
    procedure binaryInvalidHost(var handled: Boolean);
    procedure binaryStatus(Sender: TComponent; status: String);
    procedure binaryStreamInvalid(var handled: Boolean; Stream: TStream);
    procedure binaryBufferInvalid(var handled: Boolean;
      var Buff: array of Char; var length: Integer);
    procedure DeviceListChange(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }

  end;
  function fl(st:double):string;
  procedure admem(str:string);
  procedure KillSocket;
procedure update_panel_tcp;
procedure sendsoc(TCP_MODE:integer);
function calculate_MCP9700(dta:integer;VCC:double;MCP9700_Offset:double;MCP9700x:double):double;
function calculate_MCP9701(dta:integer;VCC:double;MCP9701_Offset:double;MCP9701x:double):double;
procedure RunEvent(eventcode:integer;arg1:integer;arg2:integer;arg3:integer;arg4:integer;arg5:integer;str:string);
function GetRMIndexFromAddress(adrh:integer;adrl:integer):integer;
procedure init_heat_temperature_names;
procedure loadnames_rm;
procedure readethernetdevs;
function get_index_rm(str:string):integer;
function eth_get_index_rm(str:string):integer;
function gb(chr:char):boolean;
procedure adc_hm(st:string;index:integer);
procedure adc_rm(st:string;index:integer);
function gbs(b:boolean):string;
function RMDeviceIndexByName(str:string):integer;
function ETHRMDeviceIndexByName(str:string):integer;
procedure update_panel;
function RMGetOutputStateNr(index:integer;OutputNr:integer):boolean;
function RMGetOutputState(index:integer;OutputName:string):boolean;
function RMGetInputStateNr(index:integer;InputNr:integer):boolean;
function RMGetInputState(index:integer;InputName:string):boolean;
function RMGetTempNr(index:integer;InputNr:integer):double;
function RMGetTemp(index:integer;InputName:string):double;
function RMGetInvPercent(index:integer;InputName:string):double;
function RMGetInvPercentNr(index:integer;InputNr:integer):double;
function RMGetPercent(index:integer;InputName:string):double;
function RMGetPercentNr(index:integer;InputNr:integer):double;
function RMGetDeviceOutputState(Devname:string;OutputName:string):boolean;
function RMGetDeviceInputState(Devname:string;InputName:string):boolean;
function HMGetTemp(InputName:string):double;
function HMGetTempNr(InputNr:integer):double;
function chk_int(st:string):integer;
procedure update_status;
procedure Test_save;

var path:string;   //local path
CurrentDevName:string='';
TabName:string;
Yoffset:integer=0;
tabsindex:integer=0;
statusstr:string='';
caption:string;
response:array[0..13] of integer;
CommanagerAddress:string;
CommanagerPort:string;
evnt:array [0..10] of integer;
filesystem_status:boolean=false;
tcpmode:integer=0;
BerkeleyNotComplete:boolean=true;
berkeleystatusok:boolean=false;
password:string='';
Vendor_code:array[0..6] of integer;
TimeOutClientSocket:integer=0;
remotepath:string;//zdalna sciezka - remote path tho ehouse server
oncolor:tcolor=clwhite; //button color for output ON - kolor przycisku dla wlaczonego wyjscia
offcolor:tcolor=clgray; //button color for output OFF - kolor przycisku dla wylaczonego wyjscia
ethernetdevscount:integer=0;                      //ethernet devices total count
commManagerIndex:integer;                       //index of commanager in ethernet devices array
ehouse4ethernet:boolean=false;  //ethernet controller flag
ehouse1:boolean=false;          //ehouse 1 controller flag
ehouse1version:boolean=false;          //ehouse 1 under pc supervision

//
//
//
SocketStatus:integer=0; //tcp client socket state machine
bonfire_status:string;  //status of bonfire for HeatManager
boiler_status:string;   //status of boiler for HM
Solar_status:string;    //status of solar system
recuperator_status:string;// status of recuperation, ventilation, air heating
deviceindex:integer;  //index of RM to display - indeks aktualnie wyswietlanego roommangera
ethdeviceindex:integer; //index of ERM to display - for Ethernet controllers
rows:integer=5;  //number of buttons per row to display - liczba przyciskow w jednej lini
                //all units in pixels for current screen - wymiary podane w pikselach ekranu
fontsize:integer=10; //size of font for buttons - rozmiar trzcionki dla przyciskow
labelfontsize:integer=12;   //size of font for text labels - rozmiar trzcionki dla etykiet tekstowych
labelrows:integer=3;    // number of buttons per row to display - liczba etykiet tekstowych w jednej lini
yoffsetlabel:integer=300; //offset for labels block in y axis from the top - przesuniecie bloku etykiet w osi x
colums:integer;
Buttonwidth:integer=180; //all buttons width - szerokosc przyciskow
Buttonheight:integer=30; //all buttons height - wysokosc przyciskow
LabelHeight:integer=20;  //all labels height - wysokosc etykiet tekstowych
yoffsetouts:integer=10; //offset for outputbuttons block in y axis - przesuniêcie w dol dla przyciskow wejsciowych
yoffsetprograms:integer=230; //offset for programbuttons block in y axis - przesuniecie w dol dla przyciskow programu
yoffsetadcprograms:integer=400; //offset for programbuttons block in y axis - przesuniecie w dol dla przyciskow programu
xspace:integer=3; //space between buttons in x axis - odstep miedzy przyciskami w osi x
yspace:integer=5; //space between button in y axis - odstep miedzy przyciskami w osi y
labelwidth:integer=270; //width  for all labels - szerokosc wszystkich etykiet tekstowych
labelresultsize:integer=70; //dynamic result for labels size - rozmiar pola zmiennego w etykiecie zastepowanego przez wyniki pomiarow
computername:string; //computername for unique name of panel - nazwa komputera dla unifikacji wielu paneli pracujacych jednoczesnie
devicestoupdatestatus:string='*';     //* for all devices otherwise addressh-addresslow - * gwiazdka sprawdzane wszystkie sterowniki lub "adresh-adresl" tylko dla jednego
HADC:array [0..15] of double;   //heat manager temperatures
const
TIMEOUT_TCP_SOCKET=1000;

GET_CONFIRMATION=1;
TIME_OUT_VALUE=100;
 NOTAUTHORIZED =0;


        //Heat Manager indexes for direct access of HADC array
CONST HM_GWC=3;         //GWC - Ground Heat Exchanger
      HM_KOM1=4;        //Kominek Plaszcz 1 - Bonfire water jacket 1
      HM_KOMKONV=5;     //Kominek konvekcyjne - bonfire convection
      HM_KOM2=6;        //kominek plasz 2 - bonfire water jacket 2 (backup)
      HM_TWEWN=7;       //Temperatura pokojowa wewnetrzna - internal room temperature
      HM_SOLAR=9;       //Kolektor sloneczny - solar system
      HM_ZEWNPN=8;      //Temperatura zewnetrzna polnoc - external temperature north
      HM_ZEWNPD=1;      //temperatura zewnetrzna poludnie - external temperature south
      HM_KOC=10;        // temperatura kociol - boiler temperature
      HM_BANDOL=11;     // CO/CWU zasobnik dol - hot watter buffer bottom
      HM_REQIN=12;      // rekuperator wejscie czystego powietrza - recuperation clear air input
      HM_REQOUT=13;     // rekuperator wyjscie do domu - recuperation fresh heaten air blow to room - temperature
      HM_NAG=14;        // temperatura regulowana zaworem trojdroznym za nagrzewnica lub dla kaloryferow - temperature after three ways cutoff for water heater or other heating system
      HM_REQWYC=15;     // rekuperator wyciag z domu brudne  - recuperation exhaust from home dirty temp
      HM_BANGORA=2;     // co/cwu zasobnik gora - hot water buffer TOP
      HM_BANSRO=0;      // co/cwu zasobnik srodek - hot water buffer MIDDLE
const LABEL_COUNT=30;
var HADCNames:array[0..15]  of string;
OutputNames:array[0..80] of string;             ///nazwy przycisków wyjsc - Output change buttons names
ProgramNames:array[0..24] of string;            ///nazwy przycisków programow - Program activate buttons names
ADCProgramNames:array[0..24] of string;         //nazwy przycisków programów przetworników adc - adc programs
LabelNames:array[0..LABEL_COUNT] of string;              ///nazwy czujników analogowych
ExtendedOutputNames:array[0..255] of string;    ///nazwy przycisków rozszerzonych wyjsc - extended Output change buttons names
ExtendedInputNames:array[0..96] of string;      ///nazwy rozszerzonych wejsc - extended inputs
RollersNames:array[0..128] of string;           ///nazwy przycisków wyjsc - Output change buttons names
ZonesNames:array[0..24] of string;              ///nazwy przycisków zmiany stref - zone change buttons names
ADCProgramsNames:array[0..24] of string;        ///nazwy przycisków programów przetworników - adc programs change buttons names
InputNames:array[0..96] of string;              ///nazwy wejsc - inputs


type  deviceadr=record                          //short records for keeping names and address
adrh:integer;                                   //device adress high nibble
adrl:integer;                                   //device address low nibble
recent:double;
name:string;                                    //device name
path:string;


end;
{OLD EHOUSE 1 DEVICES}
type ehouse_rm_em_hm = record                  //RoomManager, HeatManager, ExternalManager Controllers Device Status
        devname:string;                 //Device name
        lastupdate:CARDINAL;
        adrh,adrl:integer;              //Adress High, Low
        currentprogram:integer;         //Current Programm
        currentprogramname:string;      //Current Programmname
        getnewdata:boolean;             //flag new data readed
        datetime:tdatetime;
        temp1,                          //Temperature sensor LM335 all 16 ADC inputs calculated
        temp2,
        temp3,
        temp4,
        temp5,
        temp6,
        temp7,
        temp8,
        temp9,
        temp10,
        temp11,
        temp12,
        temp13,
        temp14,
        temp15,
        temp16:double;
        light1,                 //Light Level Calculated ADC Inputs
        light2,
        light3,
        light4,
        light5,
        light6,
        light7,
        light8,
        light9,
        light10,
        light11,
        light12,
        light13,
        light14,
        light15,
        light16        :double;
        adc1,                   //Adc Value calculated for ADC Inputs
        adc2,
        adc3,
        adc4,
        adc5,
        adc6,
        adc7,
        adc8,
        adc9,
        adc10,
        adc11,
        adc12,
        adc13,
        adc14,
        adc15,
        adc16


        :double;
        out1,                   //Digital current output state
        out2,
        out3,
        out4,
        out5,
        out6,
        out7,
        out8,
        out9,
        out10,
        out11,
        out12,
        out13,
        out14,
        out15,
        out16,
        out17,
        out18,
        out19,
        out20,
        out21,
        out22,
        out23,
        out24,
        out25,
        out26,
        out27,
        out28,
        out29,
        out30,
        out31,
        out32,
        out33,
        out34,
        out35:boolean;
        int1,                              //Digital input states - part 1
        int2,
        int3,
        int4,
        int5,
        int6,
        int7,
        int8:boolean;
        in1,                              //Digital input states - part 2
        in2,
        in3,
        in4,
        in5,
        in6,
        in7,
        in8:boolean;
        light1n,
        light2n,
        light3n,
        light4n:shortstring;             // PWM dimmers names
        adc1n,
        adc2n,
        adc3n,
        adc4n,
        adc5n,
        adc6n,
        adc7n,
        adc8n,
        adc9n,
        adc10n,
        adc11n,
        adc12n,
        adc13n,
        adc14n,
        adc15n,
        adc16n        :shortstring;        /// ADC Input names

        out1n,
        out2n,
        out3n,
        out4n,
        out5n,
        out6n,
        out7n,
        out8n,
        out9n,
        out10n,
        out11n,
        out12n,
        out13n,
        out14n,
        out15n,
        out16n,
        out17n,
        out18n,
        out19n,
        out20n,
        out21n,
        out22n,
        out23n,
        out24n,
        out25n,
        out26n,
        out27n,
        out28n,
        out29n,
        out30n,
        out31n,
        out32n,
        out33n,
        out34n,
        out35n:shortstring;     // outputnames
        int1n,
        int2n,
        int3n,
        int4n,
        int5n,
        int6n,
        int7n,
        int8n:shortstring;      //digital input names - part 1
        in1n,
        in2n,
        in3n,
        in4n,
        in5n,
        in6n,
        in7n,
        in8n:shortstring;       //digital input names - part 2
        RCAL1:integer;          //calibration of adc inputs
        RCAL2:integer;
        RCAL3:integer;
        RCAL4:integer;
        RCAL5:integer;
        RCAL6:integer;
        RCAL7:integer;
        RCAL8:integer;          //
        RCAL9:integer;
        RCAL10:integer;
        RCAL11:integer;
        RCAL12:integer;
        RCAL13:integer;
        RCAL14:integer;
        RCAL15:integer;
        RCAL16:integer;          //
        vcc:integer;             // Microcontroler power supplay
        extern:boolean;          //Comm manager flag
        an3temp2:boolean;        //an3 is temp value
        end;
const   TEMP_COUNT=16;
        XDOUTS_COUNT=256;
        XDINS_COUNT=256;
        DOUTS_COUNT=35;
        DINS_COUNT=32;
        XROLLERS_COUNT=128;
        XADC_PROGRAMS_COUNT=12;
        XZONES_COUNT=21;
        XPROGRAMS_COUNT=24;
type ethernet_rm_hm_cm_lm = record             //ethernet device status - Ehouse 4 Ethernet
        VCC:double;
        MCP9700x:double;   // uV/C
        MCP9701x:double;   // uV/C
        MCP9700_Offset:double ; //Offset voltage at 0 C [mV]
        MCP9701_Offset:double ; //Offset voltage at 0 C [mV]
        devname:string;         //device name
        getnewdata:boolean;
        datetime:tdatetime;
        adrh,adrl:integer;              //192.168.adrh.adrl   addressh=0
        currentprogram:integer;         //current program number
        currentprogramname:string;      //current program name
        currentzone:integer;            //current security zone for commmanager
        currentzonename:string;         //current zone name for commmanager
        currentadcprogram:integer;      //current adc program number
        currentadcprogramname:string;   //current adc program name
        temps:                  array [0..TEMP_COUNT] of double;        //temperature value if needed calculated
        tempsMCP9700:           array [0..TEMP_COUNT] of double;        //temperature value if needed calculated
        tempsMCP9701:           array [0..TEMP_COUNT] of double;        //temperature value if needed calculated
        adcsvalue:              array [0..TEMP_COUNT] of double;        //adc value according to predef settings
        adcsStringValue:        array [0..TEMP_COUNT] of string;        // string value together with suffix
        adcs:                   array [0..TEMP_COUNT] of double;        //calculate percent value
        adcsind:                array [0..TEMP_COUNT] of integer;       // index 0 .. 1023
        adcsFactor:             array [0..TEMP_COUNT] of double;        //linearity factor a (a*x+b)
        adcsOffset:             array [0..TEMP_COUNT] of double;        //offset 0 b)
        adcsVCC:                array [0..TEMP_COUNT] of double;        //reference voltage (3.3V)
        adcsPrecision:          array [0..TEMP_COUNT] of integer;       //decimal point nr (precision)
        adcsOption    :         array [0..TEMP_COUNT] of  integer;      //Additional Options
        adcssuffix    :         array [0..TEMP_COUNT] of string;        //suffix text for sensor types C, % itd
        douts:array[0..DOUTS_COUNT] of boolean;                         //digital outputs values
        dins:array[0..DINS_COUNT] of boolean;                           //digital inputs values
        adcsnames:array[0..TEMP_COUNT] of shortstring;                  //Adc inputs sensors names
        doutsnames:array[0..DOUTS_COUNT] of shortstring;                //Digital Outputs Names
        dinsnames:array[0..DINS_COUNT] of shortstring;                  //Digital Inputs Names
        xdouts:array[0..XDOUTS_COUNT] of boolean;                       //Extended Digital Outputs Values
        xdins:array[0..XDINS_COUNT] of boolean;                         //Extended Digital Inputs Values
        xalarms:array[0..XDINS_COUNT] of boolean;                       //Extended Digital Inputs for Alarm States (CommManager)
        xwarnings:array[0..XDINS_COUNT] of boolean;                     //Extended Digital Inputs for Warning States (CommManager)
        xmonitorings:array[0..XDINS_COUNT] of boolean;                  //Extended Digital Inputs for Monitoring States (CommManager)
        xdoutsnames:array[0..XDOUTS_COUNT] of shortstring;              //Extended Digital Output names
        xdinsnames:array[0..XDINS_COUNT] of shortstring;                //Extended Digital Input Names
        rollernames:array[0..XROLLERS_COUNT] of shortstring;            // Roller, Gates, Shade Awnings, Door, Windows Drives (CommManager) Names
        rollers:array[0..XROLLERS_COUNT] of integer;                    // Rollers Current State
        zonenames:array[0..XZONES_COUNT] of shortstring;                // Security zones Names (for CommManager)
        programsnames:array[0..XPROGRAMS_COUNT] of shortstring;         // Programs Names
        adcprogramsnames:array[0..XADC_PROGRAMS_COUNT] of shortstring;  // ADC program names

//        RCALS:array [0..TEMP_COUNT] of integer;
        CommManager: boolean;                                            //External=true for CommManager flag
        LevelManager:boolean;                                            //LevelManager
        roller: boolean;                                                //Roller Controler or single outputs
        secu:   boolean;                                                //Security system flag
        end;


const ROOMMANAGER_COUNT=100;                                             //Count of RoomManagers
ETHERNET_COUNT=100;                                                      //Count of EthernetControllers
var
  Form1: TForm1;

var     rm:             array [0..ROOMMANAGER_COUNT]     of ehouse_rm_em_hm;            //RoomManager,HeatManager, ExternalManager instances
        ethrm:          array [0..ETHERNET_COUNT] of ethernet_rm_hm_cm_lm;              //EthernetControllers Instances EthernetRoomManager, EthernetLevelManager, CommManager
        eth:            array [0..ETHERNET_COUNT] of deviceadr;
   buff:array [0..2047] of char;
implementation
uses binary;
{$R *.DFM}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//calculate temperature for mcp 9700 sensor data for ethernet ehouse controllers
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function calculate_MCP9700(dta:integer;VCC:double;MCP9700_Offset:double;MCP9700x:double):double;
var tmp:double;
            begin

             tmp := (((dta *  VCC ) / 1023))+MCP9700_Offset;
             //get voltage in [mv]
             tmp:=(Round((tmp/MCP9700x)*10*1000))/10;

            result:=tmp;
            end;

//calculate temperature for mcp 9701 sensor data for ethernet ehouse controllers
/////////////////////////////////////////////////////////////////////////
function calculate_MCP9701(dta:integer;VCC:double;MCP9701_Offset:double;MCP9701x:double):double;
var tmp:double;
            begin

        tmp := (((dta *  VCC ) / 1023))+MCP9701_Offset ;
             //get voltage in [mv]
             tmp:=(Round((tmp/MCP9701x)*10*1000))/10;

            result:= tmp;
            end;
////////////////////////////////////////////////////////////////////////////////
//update status of controllers captured from udp listener

procedure update_status_udp(astr:string);
var k:integer;
sr:tsearchrec;
index:integer;
str:string;
buffer:array[0..1000] of char;
DT:CARDINAL;
heatmanager:boolean;
address:string;
ch:char;
tf:textfile;
devname,tempstr:string;
adrh,adrl:string;
begin
str:=astr;
devname:=trim(copy(astr,1,pos(#13+#10,astr)));str:=copy(astr,pos(#13+#10,astr)+2,length(astr));
adrh:=trim(copy(str,1,pos(#13+#10,str)));str:=copy(str,pos(#13+#10,str)+2,length(str));
adrl:=trim(copy(str,1,pos(#13+#10,str)));str:=copy(str,pos(#13+#10,str)+2,length(str));
//while (k=0) do
        begin
        heatmanager:=false;
        index:=get_index_rm(adrh+'-'+adrl);
        if ((index>=0) and (comparetext(rm[index].devname,trim(devname))=0)) then
                 begin
                 DT:=0; //easy time stamp for change notification
//                 if (rm[index].lastupdate<>DT) then //file was changed
                        begin
                        rm[index].lastupdate:=0; //set time stamp
                        rm[index].getnewdata:=true;
                        rm[index].datetime:=now();
                        try

                        address:=adrh+'-'+adrl;
                        if (comparetext(adrh,'1')=0) then
                                        heatmanager:=true;
                           begin
                           tempstr:=trim(copy(str,1,pos(#13+#10,str)));str:=copy(str,pos(#13+#10,str)+2,length(str));//read program nr
                           rm[index].currentprogram:=chk_int(tempstr);
                           tempstr:=trim(copy(str,1,pos(#13+#10,str)));str:=copy(str,pos(#13+#10,str)+2,length(str));//read program nr//read program name
                           rm[index].currentprogramname:=(tempstr);
                           tempstr:=trim(copy(str,1,pos(#13+#10,str)));str:=copy(str,pos(#13+#10,str)+2,length(str));//read program nr
                           rm[index].out1:=gb(tempstr[1]);  //read all digital outputs
                           rm[index].out2:=gb(tempstr[2]);
                           rm[index].out3:=gb(tempstr[3]);
                           rm[index].out4:=gb(tempstr[4]);
                           rm[index].out5:=gb(tempstr[5]);
                           rm[index].out6:=gb(tempstr[6]);
                           rm[index].out7:=gb(tempstr[7]);
                           rm[index].out8:=gb(tempstr[8]);
                           rm[index].out9:=gb(tempstr[9]);
                           rm[index].out10:=gb(tempstr[10]);
                           rm[index].out11:=gb(tempstr[11]);
                           rm[index].out12:=gb(tempstr[12]);
                           rm[index].out13:=gb(tempstr[13]);
                           rm[index].out14:=gb(tempstr[14]);
                           rm[index].out15:=gb(tempstr[15]);
                           rm[index].out16:=gb(tempstr[16]);
                           rm[index].out17:=gb(tempstr[17]);
                           rm[index].out18:=gb(tempstr[18]);
                           rm[index].out19:=gb(tempstr[19]);
                           rm[index].out20:=gb(tempstr[20]);
                           rm[index].out21:=gb(tempstr[21]);
                           rm[index].out22:=gb(tempstr[22]);
                           rm[index].out23:=gb(tempstr[23]);
                           rm[index].out24:=gb(tempstr[24]);
                           rm[index].out25:=gb(tempstr[25]);
                           rm[index].out26:=gb(tempstr[26]);
                           rm[index].out27:=gb(tempstr[27]);
                           rm[index].out28:=gb(tempstr[28]);
                           rm[index].out29:=gb(tempstr[29]);
                           rm[index].out30:=gb(tempstr[30]);
                           rm[index].out31:=gb(tempstr[31]);
                           rm[index].out32:=gb(tempstr[32]);
                           rm[index].out33:=gb(tempstr[33]);
                           rm[index].out34:=gb(tempstr[34]);
                           rm[index].out35:=gb(tempstr[35]);

                        tempstr:=trim(copy(str,1,pos(#13+#10,str)));str:=copy(str,pos(#13+#10,str)+2,length(str));
                           rm[index].int1:=gb(tempstr[1]);          //read all digital inputs
                           rm[index].int2:=gb(tempstr[2]);
                           rm[index].int3:=gb(tempstr[3]);
                           rm[index].int4:=gb(tempstr[4]);
                           rm[index].int5:=gb(tempstr[5]);
                           rm[index].int6:=gb(tempstr[6]);
                           rm[index].int7:=gb(tempstr[7]);
                           rm[index].int8:=gb(tempstr[8]);
                           rm[index].in1:=gb(tempstr[9]);
                           rm[index].in2:=gb(tempstr[10]);
                           rm[index].in3:=gb(tempstr[11]);
                           rm[index].in4:=gb(tempstr[12]);
                           rm[index].in5:=gb(tempstr[13]);
                           rm[index].in6:=gb(tempstr[14]);
                           rm[index].in7:=gb(tempstr[15]);
                           rm[index].in8:=gb(tempstr[16]);
                        tempstr:=trim(copy(str,1,pos(#13+#10,str)));str:=copy(str,pos(#13+#10,str)+2,length(str));//read adc measurement results
                           if (heatmanager) then
                                begin
                                adc_hm(tempstr,index);    //assign to HeatManager
                                bonfire_status:=trim(copy(str,1,pos(#13+#10,str)));str:=copy(str,pos(#13+#10,str)+2,length(str));
                                boiler_status:=trim(copy(str,1,pos(#13+#10,str)));str:=copy(str,pos(#13+#10,str)+2,length(str));
                                Solar_status:=trim(copy(str,1,pos(#13+#10,str)));str:=copy(str,pos(#13+#10,str)+2,length(str));
                                recuperator_status:=trim(copy(str,1,pos(#13+#10,str)));str:=copy(str,pos(#13+#10,str)+2,length(str));
                                   //status of bonfire for HeatManager
                                   //status of boiler for HM
                                   //status of solar system
                                   // status of recuperation, ventilation, air heating
                                end
                           else
                                   adc_rm(tempstr,index);      //assign to RoomManagers

                           end;

                        finally;
                        end;
                        END;
                end;

        end;
end;
// Initialize heat manager temperature measurement inputs other way than RoomManager
// stored in %EHOUSE_DIR%\hmtemps.txt
//

/////////////////////////////////////////////////////////////////////////////////////
/////Init heat manager temperature sensor names
procedure init_heat_temperature_names;
var tf:textfile;
i:integer;
begin
assignfile(tf,remotepath+'hmtemps.txt');
if not fileexists(remotepath+'hmtemps.txt') then
        begin
      HADCNames[HM_GWC]:='GWC - Ground Heat Exchanger';
      HADCNames[HM_KOM1]:='Kominek Plaszcz 1 - Bonfire water jacket 1';
      HADCNames[HM_KOMKONV]:='Kominek konvekcyjne - bonfire convection';
      HADCNames[HM_KOM2]:='kominek plasz 2 - bonfire water jacket 2 (backup)';
      HADCNames[HM_TWEWN]:='Temperatura pokojowa wewnetrzna - internal room temperature';
      HADCNames[HM_SOLAR]:='Kolektor sloneczny - solar system';
      HADCNames[HM_ZEWNPN]:='Temperatura zewnetrzna polnoc - external temperature north';
      HADCNames[HM_ZEWNPD]:='temperatura zewnetrzna poludnie - external temperature south';
      HADCNames[HM_KOC]:='temperatura kociol - boiler temperature';
      HADCNames[HM_BANDOL]:='CO CWU zasobnik dol - hot watter buffer bottom';
      HADCNames[HM_REQIN]:='rekuperator wejscie czystego powietrza - recuperation clear air input';
      HADCNames[HM_REQOUT]:='rekuperator wyjscie do domu - recuperation fresh heaten air blow to room - temperature';
      HADCNames[HM_NAG]:='temperatura regulowana zaworem trojdroznym temperature after three ways cutoff';
      HADCNames[HM_REQWYC]:='rekuperator wyciag z domu brudne  - recuperation exhaust from home dirty temp';
      HADCNames[HM_BANGORA]:='co cwu zasobnik gora - hot water buffer TOP';
      HADCNames[HM_BANSRO]:='co cwu zasobnik srodek - hot water buffer MIDDLE';
      rewrite(tf);
      for i:=0 to 15 do
       writeln(tf,HADCNames[i]);
     flush(tf);
     closefile(tf);
end
else
begin
   reset(tf);
   for i:=0 to 15 do
       readln(tf,HADCNames[i]);
   closefile(tf);
end;


end;
//////////////////////////////////////////////////////////////////////////////////////
// Initialize heat manager outputs other way than RoomManager
// stored in %EHOUSE_DIR%\hmouts.txt
//

/////////////////////////////////////////////////////////////////////////////////////
procedure init_heater_outs_names(i:integer);
var tf:textfile;

str:string;
begin
assignfile(tf,remotepath+'hmouts.txt');
if fileexists(remotepath+'hmouts.txt') then
begin
   reset(tf);
//   for i:=0 to 15 do
   readln(tf,str);rm[i].out1n:=str;
   readln(tf,str);rm[i].out2n:=str;
   readln(tf,str);rm[i].out3n:=str;
   readln(tf,str);rm[i].out4n:=str;
   readln(tf,str);rm[i].out5n:=str;
   readln(tf,str);rm[i].out6n:=str;
   readln(tf,str);rm[i].out7n:=str;
   readln(tf,str);rm[i].out8n:=str;
   readln(tf,str);rm[i].out9n:=str;
   readln(tf,str);rm[i].out10n:=str;
   readln(tf,str);rm[i].out11n:=str;
   readln(tf,str);rm[i].out12n:=str;
   readln(tf,str);rm[i].out13n:=str;
   readln(tf,str);rm[i].out14n:=str;
   readln(tf,str);rm[i].out15n:=str;
   readln(tf,str);rm[i].out16n:=str;
   readln(tf,str);rm[i].out17n:=str;
   readln(tf,str);rm[i].out18n:=str;
   readln(tf,str);rm[i].out19n:=str;
   readln(tf,str);rm[i].out20n:=str;
   readln(tf,str);rm[i].out21n:=str;
   readln(tf,str);rm[i].out22n:=str;
   readln(tf,str);rm[i].out23n:=str;
   readln(tf,str);rm[i].out24n:=str;
   closefile(tf);
end;


end;



////////////////////////////////////////////////////////////////////////////////
//Read Ehouse1 devices names of inputs, outputs, adc inputs for each RoomManager, ExternalManager, HeatManager
//created in ehouse.exe application
/////////////////////////////////////////////////////////////////////////////////
procedure loadnames_rm;
var     tf:textfile;
        tf2:textfile;
        sr:tsearchrec;
        st,str:string;
        k:integer;
        i,index:integer;
        wasadrh,wasadrl:string;
begin
index:=0;
k:=findfirst(remotepath+'\devices aliases\*.dev',faanyfile-fadirectory,sr);
while k=0 do
        begin
        if comparetext(sr.name,'55-55.dev')<>0 then
        if fileexists(remotepath+'\devices aliases\'+changefileext(sr.name,'.dev')) then
                begin
                assignfile(tf,remotepath+'\devices aliases\'+changefileext(sr.name,'.dev'));
                reset(tf);
                readln(tf,rm[index].devname);           //reading device name
                readln(tf);
                readln(tf,str);
                wasadrh:=str;
                rm[index].adrh:=strtoint(str);         //dev address h
                readln(tf,str);
                rm[index].adrl:=strtoint(str);          //dev address l
                wasadrl:=str;
//                getRCALibrate(index);

                readln(tf);
                readln(tf);
                readln(tf);
                readln(tf);
                readln(tf);
                readln(tf);
                readln(tf,str);
                readln(tf,str);
                readln(tf);
                readln(tf);
                readln(tf);
                readln(tf,str);
                readln(tf,str);
                readln(tf);
                readln(tf);
                readln(tf);
                readln(tf,str);
                readln(tf,str);
                readln(tf);
                readln(tf);
                readln(tf);
                readln(tf,str);
                readln(tf,str);
                readln(tf);
                readln(tf);
                readln(tf);
              readln(tf,str);
                readln(tf,str);
                readln(tf);
                readln(tf);
                readln(tf);
                readln(tf,str);
                readln(tf,str);
                readln(tf);
                readln(tf);
                readln(tf);
              readln(tf,str);
                readln(tf,str);
                readln(tf);
                readln(tf);
                readln(tf);
                readln(tf,str);
                readln(tf,str);
                readln(tf);
                readln(tf);
                readln(tf);
                for i:=0 to 71 do
                        readln(tf);
                readln(tf,str);
                readln(tf,str);
                readln(tf,str);
                readln(tf);
                readln(tf);
                readln(tf);
                readln(tf);
                readln(tf);
                readln(tf,str);
                readln(tf,str);
                readln(tf,str);
                readln(tf);
                readln(tf);
                readln(tf);
                readln(tf);
                readln(tf);
                readln(tf,str);
                readln(tf,str);
                readln(tf,str);
                readln(tf);
                readln(tf);
                readln(tf);
                readln(tf);
                readln(tf);
                readln(tf,str);
                readln(tf,str);
                readln(tf,str);
                readln(tf);
                readln(tf);
                readln(tf);
                readln(tf);
                readln(tf);


                readln(tf,str);
                readln(tf,str);
                readln(tf,str);
                readln(tf);
                readln(tf);
                readln(tf);
                readln(tf);
                readln(tf);
                readln(tf,str);
                readln(tf,str);
                readln(tf,str);
                readln(tf);
                readln(tf);
                readln(tf);
                readln(tf);
                readln(tf);
                readln(tf,str);
                readln(tf,str);
                readln(tf,str);
                readln(tf);
                readln(tf);
                readln(tf);
                readln(tf);
                readln(tf);
                readln(tf,str);
                readln(tf,str);
                readln(tf,str);
                readln(tf);
                readln(tf);
                readln(tf);
                readln(tf);
                readln(tf);


                readln(tf,rm[index].adc1n);
                readln(tf,rm[index].adc2n);
                readln(tf,rm[index].adc3n);
                readln(tf,rm[index].adc4n);
                readln(tf,rm[index].adc5n);
                readln(tf,rm[index].adc6n);
                readln(tf,rm[index].adc7n);
                readln(tf,rm[index].adc8n);
        rm[index].getnewdata:=true;                
        readln(tf,rm[index].out1n);
        readln(tf,rm[index].out2n);
        readln(tf,rm[index].out3n);
        readln(tf,rm[index].out4n);
        readln(tf,rm[index].out5n);
        readln(tf,rm[index].out6n);
        readln(tf,rm[index].out7n);
        readln(tf,rm[index].out8n);
        readln(tf,rm[index].out9n);
        readln(tf,rm[index].out10n);
        readln(tf,rm[index].out11n);
        readln(tf,rm[index].out12n);
        readln(tf,rm[index].out13n);
        readln(tf,rm[index].out14n);
        readln(tf,rm[index].out15n);
        readln(tf,rm[index].out16n);
        readln(tf,rm[index].out17n);
        readln(tf,rm[index].out18n);
        readln(tf,rm[index].out19n);
        readln(tf,rm[index].out20n);
        readln(tf,rm[index].out21n);
        readln(tf,rm[index].out22n);
        readln(tf,rm[index].out23n);
        readln(tf,rm[index].out24n);
if (rm[index].adrh=1) and (rm[index].adrl=1) then
        init_heater_outs_names(index);

 if fileexists(remotepath+'devices aliases\'+(wasadrh)+'-'+(wasadrl)+'.oex') then
        begin
        assignfile(tf2,remotepath+'devices aliases\'+(wasadrh)+'-'+(wasadrl)+'.oex');
        reset(tf2);
        readln(tf2,st);rm[index].out25n:=st;
        readln(tf2,st);rm[index].out26n:=st;
        readln(tf2,st);rm[index].out27n:=st;
        readln(tf2,st);rm[index].out28n:=st;
        readln(tf2,st);rm[index].out29n:=st;
        readln(tf2,st);rm[index].out30n:=st;
        readln(tf2,st);rm[index].out31n:=st;
        readln(tf2,st);rm[index].out32n:=st;
        readln(tf2,st);rm[index].out33n:=st;
        readln(tf2,st);rm[index].out34n:=st;
        readln(tf2,st);rm[index].out35n:=st;
        closefile(tf2);
        end;



                readln(tf,rm[index].in1n);
                readln(tf,rm[index].in2n);
                readln(tf,rm[index].in3n);
                readln(tf,rm[index].in4n);
                readln(tf,rm[index].in5n);
                readln(tf,rm[index].in6n);
                readln(tf,rm[index].in7n);
                readln(tf,rm[index].in8n);
                readln(tf,rm[index].int1n);
                readln(tf,rm[index].int2n);
                readln(tf,rm[index].int3n);
                readln(tf,rm[index].int4n);
                readln(tf,rm[index].int5n);
                readln(tf,rm[index].int6n);
                readln(tf,rm[index].int7n);
                readln(tf,rm[index].int8n);
                readln(tf,rm[index].light1n);
                readln(tf,rm[index].light2n);
                readln(tf,rm[index].light3n);
                readln(tf,rm[index].light4n);

                readln(tf);//,rm[index].temp1n);
                readln(tf);//,rm[index].temp2n);
                readln(tf);//,rm[index].temp3n);
                readln(tf);;//,rm[index].temp4n);




                readln(tf,str);
        if (str='ON') then      rm[index].an3temp2:=true
        else                    rm[index].an3temp2:=false;
        readln(tf,str);
        if (str='ON') then rm[index].extern:=true
        else rm[index].extern:=false;


                closefile(tf);
                end;
        inc(index);
        k:=findnext(sr);
        end;
findclose(sr);

end;
/////////////////////////////////////////////////////////////////////////////////
//
// Read Ehouse 4 Ethernet devices params and names
//
////////////////////////////////////////////////////////////////////////////////
procedure readethernetdevs;
var tf,tfi:textfile;
tr:tsearchrec;
str,adrh:string;
i,m,k:integer;
adccount:integer;
begin
//
createdir(remotepath+'devs');
k:=findfirst(remotepath+'devs\*.cfg',0,tr);     //list of ethernet controllers
while k=0 do
begin
try
assignfile(tf,remotepath+'devs\'+tr.name);
reset(tf);
readln(tf,str); //address
eth[ethernetdevscount].path:=str;
adrh:=copy(str,1,3); //address high byte
str:=copy(str,4,6);  //address low byte
ethrm[ethernetdevscount].getnewdata:=true;
eth[ethernetdevscount].adrh:=chk_int(adrh);
ethrm[ethernetdevscount].adrh:=eth[ethernetdevscount].adrh;
eth[ethernetdevscount].adrl:=chk_int(str);
ethrm[ethernetdevscount].adrl:=eth[ethernetdevscount].adrl;
if ((eth[ethernetdevscount].adrh=0) and (eth[ethernetdevscount].adrl=254)) then
        commManagerIndex:=ethernetdevscount;  //commmanager flag automatically for addrl=254
readln(tf,str);
eth[ethernetdevscount].recent:=-1;
eth[ethernetdevscount].name:=str;
ethrm[ethernetdevscount].devname:=str;
ethrm[ethernetdevscount].MCP9700x:=10000;   // uV/C
ethrm[ethernetdevscount].MCP9701x:=19500;   // uV/C
ethrm[ethernetdevscount].MCP9700_Offset:=-500; //Offset voltage at 0C [mV]
ethrm[ethernetdevscount].MCP9701_Offset:=-400; //Offset voltage at 0C [mV]
ethrm[ethernetdevscount].VCC:=3300;
adccount:=0;
readln(tf,str);
ethrm[ethernetdevscount].commmanager:=false;
ethrm[ethernetdevscount].LevelManager:=false;
if (comparetext(str,'CM')=0) then
        ethrm[ethernetdevscount].CommManager:=true          //external manager flag
else if (comparetext(str,'LM')=0) then
        ethrm[ethernetdevscount].LevelManager:=true;          //external manager flag
if fileexists(remotepath+eth[ethernetdevscount].path+'\AdcNames.txt') then    //get analogue to digital converter inputs names
        begin
        try
        assignfile(tfi,remotepath+eth[ethernetdevscount].path+'\AdcNames.txt');
        reset(tfi);
        while not eof(tfi) do
                begin
                readln(tfi,str);
                if adccount<=TEMP_COUNT then
                   begin
//                   LabelNames[adccount]:=str;
                        ethrm[ethernetdevscount].adcsnames[adccount]:=str;
                   end
                else break;
                inc(adccount);
                end;
        finally
        closefile(tfi);
        end;
        end;



adccount:=0;
if (( ethrm[ethernetdevscount].CommManager) or (ethrm[ethernetdevscount].levelmanager)) then   //for cm or lm
  if fileexists(remotepath+eth[ethernetdevscount].path+'\AdditionalOutputNames.txt') then      //get additional expansion outputs names
        begin
        try
        assignfile(tfi,remotepath+eth[ethernetdevscount].path+'\AdditionalOutputNames.txt');
        reset(tfi);
        while not eof(tfi) do
                begin
                readln(tfi,str);
                if adccount<=XDOUTS_COUNT then
                        begin
                        ExtendedOutputNames[adccount]:=str;
                        ethrm[ethernetdevscount].xdoutsnames[adccount]:=str;
                        end
                else break;
                inc(adccount);
                end;
        finally
        closefile(tfi);
        end;
        end;

adccount:=0;
if fileexists(remotepath+eth[ethernetdevscount].path+'\SensorNames.txt') then    //get digital inputs names
        begin
        try
        assignfile(tfi,remotepath+eth[ethernetdevscount].path+'\SensorNames.txt');
        reset(tfi);
        while not eof(tfi) do
                begin
                readln(tfi,str);
                if adccount<=XDINS_COUNT then
                        begin
//                        LabelNames[adccount]:=str;
                        ethrm[ethernetdevscount].xdinsnames[adccount]:=str;
                        end
                else break;
                inc(adccount);
                end;
        finally
        closefile(tfi);
        end;
        end;

adccount:=0;
if ((not ethrm[ethernetdevscount].CommManager) and  (not ethrm[ethernetdevscount].levelmanager)) then      //get normal output names
     if fileexists(remotepath+eth[ethernetdevscount].path+'\OutputNames.txt') then
        begin
        try
        assignfile(tfi,remotepath+eth[ethernetdevscount].path+'\OutputNames.txt');
        reset(tfi);
        while not eof(tfi) do
                begin
                readln(tfi,str);
                if adccount<=DOUTS_COUNT then
                        begin
                        if length(trim(str))>0 then outputnames[adccount]:=trim(str);
                        ethrm[ethernetdevscount].doutsnames[adccount]:=str;
                        end
                else break;
                inc(adccount);
                end;
        finally
        closefile(tfi);
        end;
        end;


adccount:=0;
{if fileexists(remotepath+eth[ethernetdevscount].path+'\SensorNames.txt') then
        begin
        try
        assignfile(tfi,remotepath+eth[ethernetdevscount].path+'\SensorNames.txt');
        reset(tfi);
        while not eof(tfi) do
                begin
                readln(tfi,str);
                if adccount<=XDINS_COUNT then
                        ethrm[ethernetdevscount].xdinsnames[adccount]:=str
                else break;
                inc(adccount);
                end;
        finally
        closefile(tfi);
        end;
        end;

 }
adccount:=0;
if fileexists(remotepath+eth[ethernetdevscount].path+'\ADCPrograms.txt') then   //get adc programs names
        begin
        try
        assignfile(tfi,remotepath+eth[ethernetdevscount].path+'\AdcPrograms.txt');
        reset(tfi);
        while not eof(tfi) do
                begin
                readln(tfi,str);
                if adccount<=XADC_PROGRAMS_COUNT then
                        begin
                        ethrm[ethernetdevscount].adcprogramsnames[adccount]:=str;

                        end
                else break;
                inc(adccount);
                end;
        finally
        closefile(tfi);
        end;
        end;

adccount:=0;
if fileexists(remotepath+eth[ethernetdevscount].path+'\RollerNames.txt') then                           //get rollers, gateways, gates drives names
        begin
        try
        assignfile(tfi,remotepath+eth[ethernetdevscount].path+'\RollerNames.txt');
        reset(tfi);
        while not eof(tfi) do
                begin
                readln(tfi,str);
                if adccount<=XROLLERS_COUNT then
                        ethrm[ethernetdevscount].Rollernames[adccount]:=str
                else break;
                inc(adccount);
                end;
        finally
        closefile(tfi);
        end;
        end;
adccount:=0;
if fileexists(remotepath+eth[ethernetdevscount].path+'\SecuPrograms.txt') then                  //get rollers and security programs
        begin
        try
        assignfile(tfi,remotepath+eth[ethernetdevscount].path+'\SecuPrograms.txt');
        reset(tfi);
        while not eof(tfi) do
                begin
                readln(tfi,str);
                if adccount<=XPROGRAMS_COUNT then
                        ethrm[commmanagerindex].programsnames[adccount]:=str
                else break;
                inc(adccount);
                end;
        finally
        closefile(tfi);
        end;
        end;
        adccount:=0;

if fileexists(remotepath+eth[ethernetdevscount].path+'\ZonesNames.txt') then            //get zone names for CM
        begin
        try
        assignfile(tfi,remotepath+eth[ethernetdevscount].path+'\ZonesNames.txt');
        reset(tfi);
        while not eof(tfi) do
                begin
                readln(tfi,str);
                if adccount<=XZONES_COUNT then
                        ethrm[ethernetdevscount].zonenames[adccount]:=str
                else break;
                inc(adccount);
                end;

        finally
        closefile(tfi);
        end;
        end;

if ((fileexists(remotepath+eth[ethernetdevscount].path+'\AdcConfig.cfg')) and                                  //get adc configuration
        (fileexists(remotepath+eth[ethernetdevscount].path+'\ADCSensorTypes.txt'))) then
        begin
        try
        assignfile(tfi,remotepath+eth[ethernetdevscount].path+'\ADCConfig.cfg');
        reset(tfi);
        i:=0;

        while not eof(tfi) do
                begin
                readln(tfi,str);
                m:=chk_int(str); //not used here take panel seting stored in %ehouse%/panels/  directory
//                str:=get_adc_sensor_type(ethernetdevscount,m);   //not used in filemode
//                readadcparams(ethernetdevscount,path+eth[ethernetdevscount].path+'\ADCS\'+str,i); //not used in file mode
                inc(i);
                if i>TEMP_COUNT then break;
                end
        finally
        closefile(tfi);
        end;
        end;

inc(ethernetdevscount);
finally
closefile(tf);
end;

k:=findnext(tr);
end;
findclose(tr);
end;
//////////////////////////////////////////////////////////////////////////////////////
function GetComputerName: string;
var
  buffer: array[0..MAX_COMPUTERNAME_LENGTH + 1] of Char;
  Size: Cardinal;
begin
  Size := MAX_COMPUTERNAME_LENGTH + 1;
  Windows.GetComputerName(@buffer, Size);
  Result := StrPas(buffer);
  computername:=result;
end;
////////////////////////////////////////////////////////////////////////////////////
///Set configuration for buttons and labels on panels for eHouse1 Controllers
//////////////////////////////////////////////////////////////////////////////////////
procedure outputbuttonnames(index:integer);
var tt,tf:textfile;
str:string;
i:integer;

begin
if index<0 then exit;
if not directoryexists(remotepath+'panels') then createdir(remotepath+'panels');

if  fileexists(remotepath+'panels\'+rm[index].devname+'.'+computername) then //checking settings (names) for current panel first
       begin
       try
       assignfile(tf,remotepath+'panels\'+rm[index].devname+'.'+computername);
       reset(tf);
       for i:=0 to 35 do        readln(tf,       OutputNames[i]);
       for i:=0 to 24 do         readln(tf,       ProgramNames[i]);
       for i:=0 to 26 do readln(tf,LabelNames[i]);
       finally
       close(Tf);
       end;
       exit;
       end;
if  fileexists(remotepath+'panels\'+rm[index].devname+'.txt') then //checking settings for global panels
       begin
       try
       assignfile(tf,remotepath+'panels\'+rm[index].devname+'.txt');
       reset(tf);
       assignfile(tt,remotepath+'panels\'+rm[index].devname+'.'+computername);
       rewrite(tt);
       for i:=0 to 35 do        begin readln(tf,       OutputNames[i]); writeln(tt,OutputNames[i]); end;
       for i:=0 to 24 do        begin readln(tf,       ProgramNames[i]);writeln(tt,ProgramNames[i]); end;
       for i:=0 to 26 do        begin readln(tf,LabelNames[i]); writeln(tt,LabelNames[i]); end;
       finally
       close(tt);
       close(Tf);
       end;

       exit;
       end;
OutputNames[0]:=rm[index].out1n;
OutputNames[1]:=rm[index].out2n;
OutputNames[2]:=rm[index].out3n;
OutputNames[3]:=rm[index].out4n;
OutputNames[4]:=rm[index].out5n;
OutputNames[5]:=rm[index].out6n;
OutputNames[6]:=rm[index].out7n;
OutputNames[7]:=rm[index].out8n;
OutputNames[8]:=rm[index].out9n;
OutputNames[9]:=rm[index].out10n;
OutputNames[10]:=rm[index].out11n;
OutputNames[11]:=rm[index].out12n;
OutputNames[12]:=rm[index].out13n;
OutputNames[13]:=rm[index].out14n;
OutputNames[14]:=rm[index].out15n;
OutputNames[15]:=rm[index].out16n;
OutputNames[16]:=rm[index].out17n;
OutputNames[17]:=rm[index].out18n;
OutputNames[18]:=rm[index].out19n;
OutputNames[19]:=rm[index].out20n;
OutputNames[20]:=rm[index].out21n;
OutputNames[21]:=rm[index].out22n;
OutputNames[22]:=rm[index].out23n;
OutputNames[23]:=rm[index].out24n;
OutputNames[24]:=rm[index].out25n;
OutputNames[25]:=rm[index].out26n;
OutputNames[26]:=rm[index].out27n;
OutputNames[27]:=rm[index].out28n;
OutputNames[28]:=rm[index].out29n;
OutputNames[29]:=rm[index].out30n;
OutputNames[30]:=rm[index].out31n;
OutputNames[31]:=rm[index].out32n;
OutputNames[32]:=rm[index].out33n;
OutputNames[33]:=rm[index].out34n;
OutputNames[34]:=rm[index].out35n;
OutputNames[35]:='';
LabelNames[0]:=rm[index].adc1n;
LabelNames[1]:=rm[index].adc2n;
LabelNames[2]:=rm[index].adc3n;
LabelNames[3]:=rm[index].adc4n;
LabelNames[4]:=rm[index].adc5n;
LabelNames[5]:=rm[index].adc6n;
LabelNames[6]:=rm[index].adc7n;
LabelNames[7]:=rm[index].adc8n;
LabelNames[8]:='';
LabelNames[9]:='';
LabelNames[10]:='';
LabelNames[11]:='';
LabelNames[12]:='';
LabelNames[13]:='';
LabelNames[14]:='';
LabelNames[15]:='';
if (rm[index].adrh=1) then
         begin
         for  i:=0 to 15 do LabelNames[i]:=HADCNames[i];
            assignfile(tf,remotepath+'heater.evs');
                reset(tf);

                i:=0;
                while ((i<24) and (not eof(tf))) do
                         begin readln(tf,ProgramNames[i]);inc(i);end;
                while i<24 do begin ProgramNames[i]:='';inc(i);end;
                closefile(Tf);
         end
else
       begin
        if not fileexists(remotepath+'device aliases\'+inttostr(rm[index].adrh)+'-'+inttostr(rm[index].adrl)+'.pgm') then
                for i:=1 to 24 do ProgramNames[i-1]:='Program '+inttostr(i)
        else
                begin
                assignfile(tf,remotepath+'device aliases\'+inttostr(rm[index].adrh)+'-'+inttostr(rm[index].adrl)+'.pgm');
                reset(tf);
                for i:=0 to 24 do readln(tf,ProgramNames[i]);
                closefile(Tf);
                end;
         end;

assignfile(tf,remotepath+'panels\'+rm[index].devname+'.txt'); //save global panel settings
rewrite(tf);
for i:=0 to 35 do
  begin
  writeln(tf,outputnames[i]);
  end;
for i:=0 to 24 do writeln(tf,ProgramNames[i]);
if (rm[index].adrh<>1) then
        writeln(tf,LabelNames[0]+' [-%]')
else
        writeln(tf,LabelNames[0]+' [C]');
for i:=1 to 7 do writeln(tf,LabelNames[i]+' [C]');
if (RM[index].adrh=1)  then
        for i:=8 to 15 do writeln(tf,LabelNames[i]+' [C]')
else    for i:=8 to 15 do writeln(tf,'');
writeln(tf,'Current Program: %CurrentProgram%');
writeln(tf,'Current Program: %CurrentProgramName%');
if (rm[index].adrh=1) then
  begin
  writeln(tf,'Bonfire: %StatusBonfire%');
  writeln(tf,'Boiler: %StatusBoiler%');
  writeln(tf,'Vent: %StatusVentilation%');
  writeln(tf,'Solar: %StatusSolar%');
//bonfire_status:string;  //status of bonfire for HeatManager
//boiler_status:string;   //status of boiler for HM
//Solar_status:string;    //status of solar system
//recuperator_status:string;// status of recuperation, ventilation, air heating
writeln(tf,'');
writeln(tf,'');
writeln(tf,'');
writeln(tf,'');
writeln(tf,'');
writeln(tf,'');
  end;
writeln(tf,'');
writeln(tf,'');
writeln(tf,'');
writeln(tf,'');
writeln(tf,'');
writeln(tf,'');
writeln(tf,'');
writeln(tf,'');
writeln(tf,'');
writeln(tf,'');
writeln(tf,'');
writeln(tf,'');

flush(tf);
closefile(tf);

assignfile(tf,remotepath+'panels\'+rm[index].devname+'.'+computername);  //save current computer panel settings
rewrite(tf);
for i:=0 to 35 do
  begin
  writeln(tf,outputnames[i]);
  end;
for i:=0 to 24 do writeln(tf,ProgramNames[i]);
if (rm[index].adrh<>1) then
        writeln(tf,LabelNames[0]+' [-%]')
else
        writeln(tf,LabelNames[0]+' [C]');
for i:=1 to 7 do writeln(tf,LabelNames[i]+' [C]');
if (RM[index].adrh=1)  then
        for i:=8 to 15 do writeln(tf,LabelNames[i]+' [C]')
else    for i:=8 to 15 do writeln(tf,'');


writeln(tf,'Current Program: %CurrentProgram%');
writeln(tf,'Current Program: %CurrentProgramName%');
if (rm[index].adrh=1) then
  begin
  writeln(tf,'Bonfire: %StatusBonfire%');
  writeln(tf,'Boiler: %StatusBoiler%');
  writeln(tf,'Vent: %StatusVentilation%');
  writeln(tf,'Solar: %StatusSolar%')
//bonfire_status:string;  //status of bonfire for HeatManager
//boiler_status:string;   //status of boiler for HM
//Solar_status:string;    //status of solar system
//recuperator_status:string;// status of recuperation, ventilation, air heating
  end;
writeln(tf,'');
writeln(tf,'');
writeln(tf,'');
writeln(tf,'');
writeln(tf,'');
writeln(tf,'');
writeln(tf,'');
writeln(tf,'');
writeln(tf,'');
writeln(tf,'');
writeln(tf,'');
writeln(tf,'');


flush(tf);
closefile(tf);
end;


////////////////////////////////////////////////////////////////////////////////////
///Set configuration for buttons and labels on panels for Ethernet eHouse Controllers
//////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////
procedure ethoutputbuttonnames(index:integer);
var tt,tf:textfile;
str:string;
k,i:integer;

begin
if index<0 then exit;
if not directoryexists(remotepath+'panels') then createdir(remotepath+'panels');

if  fileexists(remotepath+'panels\'+ethrm[index].devname+'.'+computername) then  //checking settings (names) for current controller and for current panel first (based on computer name)
       begin
       try
       assignfile(tf,remotepath+'panels\'+ethrm[index].devname+'.'+computername);
       reset(tf);
       for i:=0 to 79 do        readln(tf,OutputNames[i]);
       for i:=0 to 23 do         readln(tf,ProgramNames[i]);
       for i:=0 to 23 do        readln(tf,ADCProgramNames[i]);
       for i:=0 to 15 do        readln(tf,LabelNames[i]);
       finally
       close(Tf);
       end;
       exit;
       end;
if  fileexists(remotepath+'panels\'+ethrm[index].devname+'.txt') then //checking settings for global panels and current controller
       begin
       try
       assignfile(tf,remotepath+'panels\'+ethrm[index].devname+'.txt');
       reset(tf);
       assignfile(tt,remotepath+'panels\'+ethrm[index].devname+'.'+computername);
       rewrite(tt);
       for i:=0 to 79 do  begin readln(tf,OutputNames[i]); writeln(tt,OutputNames[i]); end;
       for i:=0 to 23 do        begin readln(tf,ProgramNames[i]); writeln(tt,ProgramNames[i]); end;
       for i:=0 to 23 do        begin readln(tf,ADCProgramNames[i]); writeln(tt,ADCProgramNames[i]); end;
       for i:=0 to 15 do        begin readln(tf,LabelNames[i]); writeln(tt,LabelNames[i]); end;
       finally
       close(tt);
       close(Tf);
       end;

       exit;
       end;

i:=0;
  {              while ((i<24) ) do
                         begin
                         ProgramNames[i]:=ethrm[index].programsnames[i];
                         adcProgramNames[i]:=ethrm[index].ADCprogramsnames[i];
                         inc(i);end;
   }

assignfile(tf,remotepath+'panels\'+ethrm[index].devname+'.txt'); //save global panel settings
rewrite(tf);
//{for i:=0 to 79 do  writeln(tf,outputnames[i]);}
for i:=0 to 79 do  begin writeln(tf,ethrm[index].doutsnames[i]); outputnames[i]:=ethrm[index].doutsnames[i];end;
for i:=0 to 23 do  begin writeln(tf,ethrm[index].programsnames[i]); programnames[i]:=ethrm[index].programsnames[i];end;
for i:=0 to 23 do  begin writeln(tf,ethrm[index].adcprogramsnames[i]); adcprogramnames[i]:=ethrm[index].adcprogramsnames[i];end;
//for i:=0 to 23 do writeln(tf,ADCProgramNames[i]);

k:=7;
for i:=0 to k do writeln(tf,LabelNames[i]+' [C]');
inc(k);writeln(tf,LabelNames[k]+' [MCP9700]');
inc(k);writeln(tf,LabelNames[k]+' [-%]');
inc(k);
for i:=k to 15 do writeln(tf,LabelNames[i]+' [C]');
writeln(tf,'Current Program: %CurrentProgram%');
writeln(tf,'Current Program: %CurrentProgramName%');
writeln(tf,'');
writeln(tf,'');
writeln(tf,'');
writeln(tf,'');
writeln(tf,'');
writeln(tf,'');
writeln(tf,'');
writeln(tf,'');
writeln(tf,'');
writeln(tf,'');
writeln(tf,'');
writeln(tf,'');

flush(tf);
closefile(tf);

assignfile(tf,remotepath+'panels\'+ethrm[index].devname+'.'+computername);  //save panel settings for current computer name
rewrite(tf);
for i:=0 to 79 do  writeln(tf,outputnames[i]);
for i:=0 to 23 do writeln(tf,ProgramNames[i]);
for i:=0 to 23 do writeln(tf,ADCProgramNames[i]);
k:=7;
for i:=0 to k do writeln(tf,LabelNames[i]+' [C]');
inc(k);writeln(tf,LabelNames[k]+' [MCP9700]');
inc(k);writeln(tf,LabelNames[k]+' [-%]');
inc(k);
for i:=k to 15 do writeln(tf,LabelNames[i]+' [C]');


writeln(tf,'Current Program: %CurrentProgram%');
writeln(tf,'Current Program: %CurrentProgramName%');
writeln(tf,'');
writeln(tf,'');
writeln(tf,'');
writeln(tf,'');
writeln(tf,'');
writeln(tf,'');
writeln(tf,'');
writeln(tf,'');
writeln(tf,'');
writeln(tf,'');
writeln(tf,'');
writeln(tf,'');


flush(tf);
closefile(tf);
end;





////////////////////////////////////////////////////////////////////////////////////////
procedure TForm1.FormCreate(Sender: TObject);
var alignx,buttonindex,row,column,k,i:integer;
tf:textfile;
str:string;
begin
//ethernetdevscount:=0;
//devscount:=0;
if (FirstTime) then
begin
getcomputername;        //get the name of computer or panel - odczytuje nazwe

path:=getcurrentdir();   //local path get current application directory - odczytuje katalog w ktorym znajduje sie program
path:=stringreplace(path,'\bin','\',[rfignorecase] );   //get path of ehouse application
if not fileexists(path+'ehouse1.cfg') then              //old native ehouse 1 instalation under pc supervision (ehouse.exe)
        ehouse1version:=false;
assignfile(tf,path+'windowsmobilewifi-text.cfg');
vendor_code[0]:=0;
vendor_code[1]:=0;
vendor_code[2]:=0;
vendor_code[3]:=0;
vendor_code[4]:=0;
vendor_code[5]:=0;
reset(tf);
readln(tf);
readln(tf,str);//commanager address and port
CommanagerAddress:=copy(str,1,pos(':',str)-1);
CommanagerPort:=copy(str,pos(':',str)+1,length(str));
readln(tf);
readln(tf);
readln(tf);
readln(tf);
readln(tf);
readln(tf);
//readln(tf);
readln(tf,Password);  //password for xored password verification
readln(tf,str);
closefile(tf);
remotepath:=path;        //the same path for remoteaccess for inicialization - na pocz¹tku przyporz¹dkowywuje t¹ sam¹ scie¿kê dla zdalnego dostêpu
createdir(path+'logs');
createdir(path+'logs\status');
loadnames_rm;                   //load ehouse1 controller names
init_heat_temperature_names;    //init heatmanager names
readethernetdevs;               //load ethernet ehouse controllers names
//end;
//if (FirstTime) then
//        begin
        if (DeviceList.visible) then
                begin
                Yoffset:= Devicelist.TabHeight+10;
                Panel1.width:=form1.clientwidth;
                DeviceList.width:=panel1.clientwidth;
                end
        else Yoffset:=0;
        Devicelist.Tabs.clear;
        for i:=0 to ETHERNET_COUNT do
          if length(Ethrm[i].devname)>0 then
            if (pos('TEMPLATE_',Ethrm[i].devname)=0) then
                DeviceList.Tabs.Add(Ethrm[i].devname)
          else break;
        for i:=0 to ROOMMANAGER_COUNT do
          if length(rm[i].devname)>0 then
            if (pos('TEMPLATE_',rm[i].devname)=0) then
                DeviceList.Tabs.Add(rm[i].devname)
          else break;


        end;
i:=1;
if (FirstTime) then
begin
while i<=paramcount do                                //perform command line arguments
  begin
  if ((pos('/?',lowercase(paramstr(i)))>0) or (paramcount<1)) then
          begin
          showmessage('Available Params: '+#13+#10+
            '/x:panel width'+#13+#10+
            '/y:panel height'+#13+#10+
            '/r:device name'+#13+#10+
            '/p:path to remote files'+#13+#10+
            '/a:device address');
          end;
  if pos('/x:',lowercase(paramstr(i)))=1 then  //panel width
                form1.Width:=chk_int(stringreplace(paramstr(i),'/x:','',[rfignorecase]));
  if pos('/y:',lowercase(paramstr(i)))=1 then  //panel height
                form1.height:=chk_int(stringreplace(paramstr(i),'/y:','',[rfignorecase]));
  if pos('/r:',lowercase(paramstr(i)))=1 then  //device name (RoomManager)
                begin
                deviceindex:=RMDeviceIndexByName((stringreplace(paramstr(i),'/r:','',[rfignorecase])));
                ethdeviceindex:=ETHRMDeviceIndexByName((stringreplace(paramstr(i),'/r:','',[rfignorecase])));
                end;
  if pos('/a:',lowercase(paramstr(i)))=1 then  //device address (RoomManager)
                begin
                deviceindex:=(get_index_rm(stringreplace(paramstr(i),'/a:','',[rfignorecase])+'.'));
                ethdeviceindex:=(eth_get_index_rm(stringreplace(paramstr(i),'/a:','',[rfignorecase])+'.'));
                end;
  if pos('/p:',lowercase(paramstr(i)))=1 then  //remote access  path
                remotepath:=((stringreplace(paramstr(i),'/p:','',[rfignorecase])));
  inc(i);
  end;
end 
   else //not first time
        begin
        deviceindex:=RMDeviceIndexByName(TabName);
        ethdeviceindex:=ETHRMDeviceIndexByName(Tabname);

        end;

if form1.width<100  then form1.width:=1024; //if wrong parameters for size sets default - wartosci domyslne
if form1.height<100 then form1.height:=800;
        CurrentDevName:='';
if deviceindex>=0 then
                        begin
                        ehouse4ethernet:=false;
                        ehouse1:=true;
                        caption:='eHouse Control Panel: '+rm[deviceindex].devname;  //set caption of main form do RoomManager Name - pokazuje w naglowku formularza nazwe roommanagera
                        admem('');
                        CurrentDevName:=rm[deviceindex].devname;
                        devicestoupdatestatus:=inttostr(rm[deviceindex].adrh)+'-'+inttostr(rm[deviceindex].adrl);
                        for i:=0 to form1.ComponentCount-1 do
                          if (form1.Components[i] is tpanel) then
                               if pos('adcprogram',lowercase((form1.components[i] as tpanel).name))>0 then   //if name consist (adcprogram)
                                        (form1.components[i] as tpanel).visible:=false
                               else      (form1.components[i] as tpanel).visible:=true;
                        end;
if ethdeviceindex>=0 then
                        begin
                        CurrentDevName:=ethrm[ethdeviceindex].devname;
                        ehouse4ethernet:=true;
                        ehouse1:=false;
                        devicestoupdatestatus:=inttostr(ethrm[deviceindex].adrh)+'.'+inttostr(ethrm[deviceindex].adrl);
                        caption:='eHouse Control Panel: '+ethrm[deviceindex].devname;  //set caption of main form do RoomManager Name - pokazuje w naglowku formularza nazwe roommanagera
                        admem('');
                        for i:=0 to sizeof(LabelNames) do
                                BEGIN
                                 IF (I<16)  then LabelNames[i]:=EthRm[ethdeviceindex].adcsnames[i]
                                 else LabelNames[i]:='';
                                 END;
                        end;

        //limit searching status for current roommanager /filter out other devices
        //single device check for pannel for limitation utilisation
        //sprawdza tylko status wybranego roommanagera wielokrotnie mniejsze obciazenie procesora i serwera eHouse
if deviceindex>=0 then        outputbuttonnames(deviceindex);  //initialize buttons and labels names  - inicjalizuje nazwy przyciskow i etykiet tekstowych
if ethdeviceindex>=0 then       ethoutputbuttonnames(ethdeviceindex);
timer1.interval:=3000;          // set cyclic task interval in miliseconds
timer1.Enabled:=true;           //start automatic tasks (status update
k:=1;
buttonindex:=0;                 //current button (visible) index - numer bie¿¹cego przycisku (widocznego)
row:=0;                         //current button in row - numer aktualnego przycisku w bie¿¹cej linii
//column:=0;
alignx:=(form1.clientWidth-(rows)*(buttonwidth+xspace))div 2;  //center buttons on panel - wycentrowanie blokow przyciskow
yoffsetouts:=yoffsetouts+Yoffset;

for i:=0 to form1.ComponentCount-1 do //automatic Output button setup - automatyczne konfigurowanie przyciskow Wyjsc
  begin   //for each object on form1 - dla wszystkich elementow na Form1
  if (form1.Components[i] is tpanel) then  //if object is Tpanel (our button) - jesli obiekt typu Tpanel (przycisk)
  begin
//  showmessage((form1.components[i] as tbutton).name);
    if comparetext((form1.components[i] as tpanel).name,'output'+inttostr(k))=0 then   //if name consist (output)
       begin

       row:=buttonindex mod (rows);    //calculate rows and columns indexes - oblicza wspolzedne kolumny i wiersza
       column:=buttonindex div (rows);
if ((length(OutputNames[k-1])>1) and // Only shows ouput buttons with the name - tylko pokazuje przyciski z nazwa
   (pos('@',OutputNames[k-1])=0)) then
        begin
       (form1.Components[i] as tpanel).left:=alignx+row*(buttonwidth+xspace); //calculate X axis possition - oblicza pozycje w osi X
       (form1.Components[i] as tpanel).top:=yoffsetouts+column*(buttonheight+yspace); //calculate Y axis possition - oblicza pozycje w osi Y
       (form1.Components[i] as tpanel).width:=buttonwidth;   //Set Buttons Width - Szerokosc przyciskow
       (form1.Components[i] as tpanel).height:=buttonheight;  //Set Buttons Height - Wysokosc przyciskow
       (form1.components[i] as tpanel).caption:=Outputnames[k-1]; //Set Button Caption - ustawia tekst przycisku
       (form1.components[i] as tpanel).Bevelinner:=bvRaised;
       (form1.components[i] as tpanel).BevelOuter:=bvRaised;
       (form1.components[i] as tpanel).font.Size:=fontsize;      //Set Button Font Size - ustawia rozmiar czcionki dla przycisku
       inc(buttonindex);     //next visible button - nastêpny widoczny przycisk
        (form1.components[i] as tpanel).visible:=true;
        end
else
 if (length(OutputNames[k-1])=1) then //rozmiar 11
        begin
        (form1.components[i] as tpanel).visible:=false;    //1 char name = do not show button live space- usuwa przyciski bez nazw zostawia puste miejsce
        inc(buttonindex);
        end
 else     (form1.components[i] as tpanel).visible:=false;    //no name = do not show button - usuwa przyciski bez nazw
 inc(k);  // next button - nastêpny przycisk
       end;
  end;
  end;
  YOFFSETPROGRAMS:=yoffsetouts+(COLUMN+1)*(buttonheight+yspace)+BUTTONHEIGHT+Yoffset;

//////////// The same for program buttons - Analogicznie dla przyciskow do uruchamiania programow

buttonindex:=0;
k:=1;
for i:=0 to form1.ComponentCount-1 do
  begin
  if (form1.Components[i] is tpanel) then
  begin
    if comparetext((form1.components[i] as tpanel).name,'program'+inttostr(k))=0 then
       begin

       row:=buttonindex mod (rows);
       column:=buttonindex div (rows);
if ((length(ProgramNames[k-1])>1) and // Only shows ouput buttons with the name - tylko pokazuje przyciski z nazwa
   (pos('@',ProgramNames[k-1])=0)) then
        begin
       (form1.Components[i] as tpanel).left:=alignx+row*(buttonwidth+xspace);
       (form1.Components[i] as tpanel).top:=yoffsetprograms+column*(buttonheight+yspace);
       (form1.Components[i] as tpanel).width:=buttonwidth;
       (form1.Components[i] as tpanel).height:=buttonheight;
       (form1.components[i] as tpanel).caption:=Programnames[k-1];  //set button caption for program buttons - ustawia nazwy przycisków programu
       (form1.components[i] as tpanel).Bevelinner:=bvRaised;
       (form1.components[i] as tpanel).BevelOuter:=bvRaised;
       (form1.components[i] as tpanel).font.Size:=fontsize;
       (form1.components[i] as tpanel).visible:=true;
       inc(buttonindex);
        end
else
        if length(ProgramNames[k-1])=1 then
                begin
                (form1.components[i] as tpanel).visible:=false;
                inc(buttonindex);
                end
        else (form1.components[i] as tpanel).visible:=false;
       inc(k);
       end;
  end;
  end;
if  ethdeviceindex>=0 then
        YOFFSETADCPROGRAMS:=yoffsetprograms+(COLUMN+1)*(buttonheight+yspace)+BUTTONHEIGHT
else YOFFSETADCPROGRAMS:=yoffsetprograms;  //no adc programs
YOFFSETADCPROGRAMS:=YOFFSETADCPROGRAMS  +Yoffset;
if (ethdeviceindex>=0) then
  begin
buttonindex:=0;
k:=1;
for i:=0 to form1.ComponentCount-1 do
  begin
  if (form1.Components[i] is tpanel) then
  begin
    if comparetext((form1.components[i] as tpanel).name,'adcprogram'+inttostr(k))=0 then
       begin
       row:=buttonindex mod (rows);
       column:=buttonindex div (rows);
        if ((length(ADCProgramNames[k-1])>1) and // Only shows ouput buttons with the name - tylko pokazuje przyciski z nazwa
           (pos('@',ADCProgramNames[k-1])=0)) then  //if not @ char in the name display button
                begin
               (form1.Components[i] as tpanel).left:=alignx+row*(buttonwidth+xspace);
               (form1.Components[i] as tpanel).top:=yoffsetadcprograms+column*(buttonheight+yspace);
               (form1.Components[i] as tpanel).width:=buttonwidth;
               (form1.Components[i] as tpanel).height:=buttonheight;
               (form1.components[i] as tpanel).caption:=ADCProgramnames[k-1];  //set button caption for program buttons - ustawia nazwy przycisków programu
               (form1.components[i] as tpanel).Bevelinner:=bvRaised;
               (form1.components[i] as tpanel).BevelOuter:=bvRaised;
               (form1.components[i] as tpanel).font.Size:=fontsize;
               (form1.components[i] as tpanel).visible:=true;
               inc(buttonindex);
                end
        else
                if length(ADCProgramNames[k-1])=1 then                  //if length of name = 1  then do not display button but allocate space for button
                        begin
                        (form1.components[i] as tpanel).visible:=false;
                        inc(buttonindex);
                        end
                else (form1.components[i] as tpanel).visible:=false;    //otherwise do not display button and do not allocate space
       inc(k);
       end;
  end;
  end;




  end;
YOFFSETLABEL:=yoffsetADCprograms+(COLUMN+1)*(buttonheight+yspace)+BUTTONHEIGHT+YOFFSET;
k:=1;
buttonindex:=0;
///////Analogicaly for Labels - Analogicznie dla etykiet
for i:=0 to form1.ComponentCount-1 do
  begin
  if (form1.Components[i] is tlabel) then
  begin

    if comparetext((form1.components[i] as tlabel).name,'label'+inttostr(k))=0 then
       begin

       row:=buttonindex mod (labelrows);
       column:=buttonindex div (labelrows);
if ((length(LabelNames[k-1])>1)
        and // Only shows ouput buttons with the name - tylko pokazuje przyciski z nazwa
   (pos('@',LabelNames[k-1])=0)) then      //if length of label text > 0  - jesli opis istnieje
        begin
       (form1.Components[i] as tlabel).left:=alignx+row*(labelwidth+xspace+labelresultsize); //calculate X location
       (form1.Components[i] as tlabel).top:=yoffsetlabel+column*(labelheight+yspace); //calculate Y location
       (form1.Components[i] as tlabel).width:=labelwidth;
       (form1.Components[i] as tlabel).height:=labelheight;
       (form1.components[i] as tlabel).caption:=LabelNames[k-1];  ///assign label captions - nadaje naglowki etykietom
        (form1.components[i] as tlabel).visible:=true;
        (form1.components[i] as tlabel).font.color:=clwhite; //set default color for label - ustawia domyslny kolor dla etykiety
        if pos('[-%]',LabelNames[k-1])>0 then         (form1.components[i] as tlabel).font.color:=clyellow //set color for light measurement - kolor dla pomiaru oswietlenia
        else if pos('[%]',LabelNames[k-1])>0 then         (form1.components[i] as tlabel).font.color:=claqua   //set color for percent measurement - kolor dla wartosci procentowej
        else if pos('[C]',LabelNames[k-1])>0 then         (form1.components[i] as tlabel).font.color:=clwhite //set color for temperature management - kolor dla wartosci temperatury
        else (form1.components[i] as tlabel).font.color:=clpurple;
        (form1.components[i] as tlabel).font.Size:=labelfontsize; //set font size for label - ustawia rozmiar czcionki dla etykiety tekstowej
        inc(buttonindex); //next visible label - nastepna widoczna etykieta
        end

else
if length(LabelNames[k-1])=1 then      //if length of label text > 0  - jesli opis istnieje
        begin
        (form1.components[i] as tlabel).visible:=false;   //hide labels without text - ukrywa etykiety bez textu
           inc(buttonindex); //next visible label - nastêpna widoczna etykieta
        end
else        (form1.components[i] as tlabel).visible:=false;   //hide labels without text - ukrywa etykiety bez textu
       inc(k); //next label - nastêpna etykieta
       end;
  end;
  end;
if (filesystem_status) then update_status;

Yoffset:=0;

if (not FirstTime) then
        begin
        update_panel;
        update_panel_tcp;
        end
else
        begin
        if length(CurrentDevName) > 0 then
        if devicelist.tabs.IndexOf(currentdevname)>=0 then
                devicelist.tabindex:=devicelist.tabs.IndexOf(currentdevname);
        end;
//FirstTime:=false;
get_hm_desc;
set_rm(buff,1);
end;
/////////////////////////////////////////////////////////////////////////////////
//
// check integer and convert from string
//
/////////////////////////////////////////////////////////////////////////////////
function chk_int(st:string):integer;
var d:integer;
code:integer;
begin
val(st,d,code);
if code=0 then result:=d
else result:=-1;
end;
/////////////////////////////////////////////////////////////////////////



////////////////////////////////////////////////////////////////////////////////
//
// Return index of RM record from file name
//
/////////////////////////////////////////////////////////////////////////////////
function get_index_rm(str:string):integer;
var adrh,adrl:integer;
ind:integer;
st:string;
begin
result:=-1;
if pos('-',str)=0 then result:=-1
else
   begin
   adrh:=chk_int(copy(str,1,pos('-',str)-1));  //first part is address h
   st:=(copy(str,pos('-',str)+1,length(str)));
   if (pos('.',str)>0) then    st:=(copy(st,1,pos('.',st)-1));

   adrl:=chk_int(st);                                                          //second part is adr l
   end;
   ind:=0;
while (length(rm[ind].devname)>1) do                                            //search all rm items
   begin
   if ((adrh=rm[ind].adrh) and (adrl=rm[ind].adrl)) then
      begin
      result:=ind;
      break;
      end
   else   inc(ind);
   end;

end;
/////////////////////////////////////////////////////////////////////////////////
function eth_get_index_rm(str:string):integer;
var adrh,adrl:integer;
ind:integer;
st:string;
begin
result:=-1;
if pos('-',str)=0 then result:=-1
else
   begin
   adrh:=chk_int(copy(str,1,pos('-',str)-1));  //first part is address h
   st:=(copy(str,pos('-',str)+1,length(str)));
   if (pos('.',str)>0) then    st:=(copy(st,1,pos('.',st)-1));

   adrl:=chk_int(st);                                                          //second part is adr l
   end;
   ind:=0;
while (length(ethrm[ind].devname)>1) do                                            //search all rm items
   begin
   if ((adrh=ethrm[ind].adrh) and (adrl=ethrm[ind].adrl)) then
      begin
      result:=ind;
      break;
      end
   else   inc(ind);
   end;

end;


////////////////////////////////////////////////////////////////////////////////
//
// get boolean value from text status file
//
/////////////////////////////////////////////////////////////////////////////////
function gb(chr:char):boolean;
begin
result:=false;
if chr='0' then result:=false;
if chr='1' then result:=true;
end;
////////////////////////////////////////////////////////////////////////////////
//
// Read ADC (temperatures) for HeatManager tab separated one by one and stores in RM[index] record
//
////////////////////////////////////////////////////////////////////////////////
procedure adc_hm(st:string;index:integer);
var ind:integer;
str,tempstr:string;
temp:double;
begin
str:=st+#9;
ind:=0;
for ind:=0 to 15 do HADC[ind]:=0;
RM[index].temp1:=0;
RM[index].temp2:=0;
RM[index].temp3:=0;
RM[index].temp4:=0;
RM[index].temp5:=0;
RM[index].temp6:=0;
RM[index].temp7:=0;
RM[index].temp8:=0;
RM[index].temp9:=0;
RM[index].temp10:=0;
RM[index].temp11:=0;
RM[index].temp12:=0;
RM[index].temp13:=0;
RM[index].temp14:=0;
RM[index].temp15:=0;
RM[index].temp16:=0;
ind:=0;
while pos(#9,str)>0 do
  begin
  tempstr:=trim(copy(str,1,pos(#9,str)));
  tempstr:=stringreplace(tempstr,'.',decimalseparator,[rfreplaceall]);
  tempstr:=stringreplace(tempstr,',',decimalseparator,[rfreplaceall]);
  temp:=strtofloat(tempstr);
  str:=(copy(str,pos(#9,str)+1,length(str)));
  HADC[ind]:=temp;
  case ind of
        0:RM[index].temp1:=temp;
        1:RM[index].temp2:=temp;
        2:RM[index].temp3:=temp;
        3:RM[index].temp4:=temp;
        4:RM[index].temp5:=temp;
        5:RM[index].temp6:=temp;
        6:RM[index].temp7:=temp;
        7:RM[index].temp8:=temp;
        8:RM[index].temp9:=temp;
        9:RM[index].temp10:=temp;
        10:RM[index].temp11:=temp;
        11:RM[index].temp12:=temp;
        12:RM[index].temp13:=temp;
        13:RM[index].temp14:=temp;
        14:RM[index].temp15:=temp;
        15:RM[index].temp16:=temp;
  end;
  inc(ind);
  end;
end;
/////////////////////////////////////////////////////////////////////////////////
//
// Set ADC Results for current RoomManager (input values string, index of RM
//
////////////////////////////////////////////////////////////////////////////////
procedure adc_rm(st:string;index:integer);
var ind:integer;
str,tempstr:string;
temp:double;
arr:integer;
begin
str:=st+#9;
ind:=0;
RM[index].temp1:=0;
RM[index].temp2:=0;
RM[index].temp3:=0;
RM[index].temp4:=0;
RM[index].temp5:=0;
RM[index].temp6:=0;
RM[index].temp7:=0;
RM[index].temp8:=0;
RM[index].temp9:=0;
RM[index].temp10:=0;
RM[index].temp11:=0;
RM[index].temp12:=0;
RM[index].temp13:=0;
RM[index].temp14:=0;
RM[index].temp15:=0;
RM[index].temp16:=0;
RM[index].light1:=0;
RM[index].light2:=0;
RM[index].light3:=0;
RM[index].light4:=0;
RM[index].light5:=0;
RM[index].light6:=0;
RM[index].light7:=0;
RM[index].light8:=0;
RM[index].light9:=0;
RM[index].light10:=0;
RM[index].light11:=0;
RM[index].light12:=0;
RM[index].light13:=0;
RM[index].light14:=0;
RM[index].light15:=0;
RM[index].light16:=0;
RM[index].adc1:=0;
RM[index].adc2:=0;
RM[index].adc3:=0;
RM[index].adc4:=0;
RM[index].adc5:=0;
RM[index].adc6:=0;
RM[index].adc7:=0;
RM[index].adc8:=0;
RM[index].adc9:=0;
RM[index].adc10:=0;
RM[index].adc11:=0;
RM[index].adc12:=0;
RM[index].adc13:=0;
RM[index].adc14:=0;
RM[index].adc15:=0;
RM[index].adc16:=0;
ind:=0;  arr:=0;
while pos(#9,str)>0 do
  begin
  tempstr:=trim(copy(str,1,pos(#9,str)));
  tempstr:=stringreplace(tempstr,'.',decimalseparator,[rfreplaceall]);
  tempstr:=stringreplace(tempstr,',',decimalseparator,[rfreplaceall]);
  temp:=strtofloat(tempstr);
  str:=(copy(str,pos(#9,str)+1,length(str)));
  if (arr=0) then
    begin
        case ind of                               //temperature calculated value
        0:RM[index].temp1:=temp;
        1:RM[index].temp2:=temp;
        2:RM[index].temp3:=temp;
        3:RM[index].temp4:=temp;
        4:RM[index].temp5:=temp;
        5:RM[index].temp6:=temp;
        6:RM[index].temp7:=temp;
        7:begin RM[index].temp8:=temp;ind:=-1;inc(arr);end;
{        8:RM[index].temp9:=temp;
        9:RM[index].temp10:=temp;
        10:RM[index].temp11:=temp;
        11:RM[index].temp12:=temp;
        12:RM[index].temp13:=temp;
        13:RM[index].temp14:=temp;
        14:RM[index].temp15:=temp;
        15:RM[index].temp16:=temp;}
        end;
   end
  else
    if (arr=1) then
    begin
        case ind of                             //inverted % calculated value
        0:RM[index].light1:=temp;
        1:RM[index].light2:=temp;
        2:RM[index].light3:=temp;
        3:RM[index].light4:=temp;
        4:RM[index].light5:=temp;
        5:RM[index].light6:=temp;
        6:RM[index].light7:=temp;
        7:begin RM[index].light8:=temp;ind:=-1;inc(arr);end;
{        8:RM[index].light9:=temp;
        9:RM[index].light10:=temp;
        10:RM[index].light11:=temp;
        11:RM[index].light12:=temp;
        12:RM[index].light13:=temp;
        13:RM[index].light14:=temp;
        14:RM[index].light15:=temp;
        15:RM[index].light16:=temp;}
        end;
   end
  else
    if (arr=2) then                     //% percent calculated value
    begin
        case ind of
        0:RM[index].adc1:=temp;
        1:RM[index].adc2:=temp;
        2:RM[index].adc3:=temp;
        3:RM[index].adc4:=temp;
        4:RM[index].adc5:=temp;
        5:RM[index].adc6:=temp;
        6:RM[index].adc7:=temp;
        7:begin RM[index].adc8:=temp;ind:=-1;inc(arr);end;
{        8:RM[index].adc9:=temp;
        9:RM[index].adc10:=temp;
        10:RM[index].adc11:=temp;
        11:RM[index].adc12:=temp;
        12:RM[index].adc13:=temp;
        13:RM[index].adc14:=temp;
        14:RM[index].adc15:=temp;
        15:RM[index].adc16:=temp;}
        end;
   end;

  inc(ind);
  end;
end;



////////////////////////////////////////////////////////////////////////////////
//
//
// update eHouse 1 dev (RM,HM) status from ehouse.exe statuses copy in logs/status/
//
////////////////////////////////////////////////////////////////////////////////
procedure update_status;
var k:integer;
sr:tsearchrec;
index:integer;
str:string;
buffer:array[0..1000] of char;
DT:CARDINAL;
heatmanager:boolean;
address:string;
ch:char;
tf:textfile;
begin
if not filesystem_status then exit;
k:=findfirst(remotepath+'logs\status\'+devicestoupdatestatus+'.status',faanyfile-fadirectory,sr);
while (k=0) do
        begin
        heatmanager:=false;
        index:=get_index_rm(sr.name);
        if (index>=0) then
                 begin
                 DT:=sr.FindData.ftLastWriteTime.dwHighDateTime+sr.FindData.ftLastWriteTime.dwLowDateTime; //easy time stamp for change notification
                 if (rm[index].lastupdate<>DT) then //file was changed
                        begin
                        rm[index].lastupdate:=DT; //set time stamp
                        rm[index].getnewdata:=true;
                        rm[index].datetime:=now();
                        try
                        copyfile(Pchar(remotepath+'logs\status\'+sr.name),Pchar(changefileext(path+'logs\status\'+sr.name,'.'+computername)),false); //copy file to avoid multiple file access issues
                        assignfile(tf,changefileext(path+'logs\status\'+sr.name,'.'+computername)); //reading copy of text status file
                        reset(tf);
                        readln(tf);     //devicename;
                        readln(tf,str); //dev address high
                        address:=str;
                        if (comparetext(str,'1')=0) then
                                        heatmanager:=true;
                        readln(tf,str); //dev address low
                        address:=address+'-'+str;
                        if comparetext(address+'.status',sr.name)=0 then //second time address comparison for verification
                           begin
                           readln(tf,str);//read program nr
                           rm[index].currentprogram:=chk_int(str);
                           readln(tf,str);//read program name
                           rm[index].currentprogramname:=(str);
                           read(tf,ch);rm[index].out1:=gb(ch);  //read all digital outputs
                           read(tf,ch);rm[index].out2:=gb(ch);
                           read(tf,ch);rm[index].out3:=gb(ch);
                           read(tf,ch);rm[index].out4:=gb(ch);
                           read(tf,ch);rm[index].out5:=gb(ch);
                           read(tf,ch);rm[index].out6:=gb(ch);
                           read(tf,ch);rm[index].out7:=gb(ch);
                           read(tf,ch);rm[index].out8:=gb(ch);
                           read(tf,ch);rm[index].out9:=gb(ch);
                           read(tf,ch);rm[index].out10:=gb(ch);
                           read(tf,ch);rm[index].out11:=gb(ch);
                           read(tf,ch);rm[index].out12:=gb(ch);
                           read(tf,ch);rm[index].out13:=gb(ch);
                           read(tf,ch);rm[index].out14:=gb(ch);
                           read(tf,ch);rm[index].out15:=gb(ch);
                           read(tf,ch);rm[index].out16:=gb(ch);
                           read(tf,ch);rm[index].out17:=gb(ch);
                           read(tf,ch);rm[index].out18:=gb(ch);
                           read(tf,ch);rm[index].out19:=gb(ch);
                           read(tf,ch);rm[index].out20:=gb(ch);
                           read(tf,ch);rm[index].out21:=gb(ch);
                           read(tf,ch);rm[index].out22:=gb(ch);
                           read(tf,ch);rm[index].out23:=gb(ch);
                           read(tf,ch);rm[index].out24:=gb(ch);
                           read(tf,ch);rm[index].out25:=gb(ch);
                           read(tf,ch);rm[index].out26:=gb(ch);
                           read(tf,ch);rm[index].out27:=gb(ch);
                           read(tf,ch);rm[index].out28:=gb(ch);
                           read(tf,ch);rm[index].out29:=gb(ch);
                           read(tf,ch);rm[index].out30:=gb(ch);
                           read(tf,ch);rm[index].out31:=gb(ch);
                           read(tf,ch);rm[index].out32:=gb(ch);
                           read(tf,ch);rm[index].out33:=gb(ch);
                           read(tf,ch);rm[index].out34:=gb(ch);
                           read(tf,ch);rm[index].out35:=gb(ch);
                           readln(tf,str);//to the end of line
                           read(tf,ch);rm[index].int1:=gb(ch);          //read all digital inputs
                           read(tf,ch);rm[index].int2:=gb(ch);
                           read(tf,ch);rm[index].int3:=gb(ch);
                           read(tf,ch);rm[index].int4:=gb(ch);
                           read(tf,ch);rm[index].int5:=gb(ch);
                           read(tf,ch);rm[index].int6:=gb(ch);
                           read(tf,ch);rm[index].int7:=gb(ch);
                           read(tf,ch);rm[index].int8:=gb(ch);
                           read(tf,ch);rm[index].in1:=gb(ch);
                           read(tf,ch);rm[index].in2:=gb(ch);
                           read(tf,ch);rm[index].in3:=gb(ch);
                           read(tf,ch);rm[index].in4:=gb(ch);
                           read(tf,ch);rm[index].in5:=gb(ch);
                           read(tf,ch);rm[index].in6:=gb(ch);
                           read(tf,ch);rm[index].in7:=gb(ch);
                           read(tf,ch);rm[index].in8:=gb(ch);
                           readln(tf,str);//to the end of line
                           readln(tf,str);//read adc measurement results
                           if (heatmanager) then
                                begin
                                   adc_hm(str,index);    //assign to HeatManager
                                   readln(tf,bonfire_status);  //status of bonfire for HeatManager
                                   readln(tf,boiler_status);   //status of boiler for HM
                                   readln(tf,Solar_status);    //status of solar system
                                   readln(tf,recuperator_status);// status of recuperation, ventilation, air heating
                                end
                           else
                                   adc_rm(str,index);      //assign to RoomManagers

                           end;
                        closefile(tf);

                        finally;
                        end;
                        END;
                end;
        k:=findnext(sr);

        end;
findclose(sr);
end;
////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
//
// boolean to string
//
///////////////////////////////////////////////////////////////////////////////
function gbs(b:boolean):string;
begin
result:='0';
if b=true then result:='1';

end;

///////////////////////////////////////////////////////////////////////////////
//
// Test saving result for verification
//
//////////////////////////////////////////////////////////////////////////////
procedure Test_save;
var tf:textfile;
str:string;
i,index:integer;

begin
index:=0;
while length(rm[index].devname)>0 do
//   with rm[index] do
begin
if rm[index].getnewdata then

   begin
   rm[index].getnewdata:=false;

   assignfile(tf,path+'logs\'+rm[index].devname+'_test.txt');
   rewrite(tf);

   writeln(tf,'Device Name / Nazwa urzadzenia: '+ rm[index].devname);
   writeln(tf,'Device Address / Adres urzadzenia: ('+inttostr(rm[index].adrh)+','+inttostr(rm[index].adrl)+')');
   writeln(tf,'Date: '+datetimetostr(rm[index].datetime));
   writeln(tf,'------------------------------------------------------------------------------');
   writeln(tf,'Current program / biezacy program: '+inttostr(rm[index].currentprogram));
   writeln(tf,'Current program name / biezacy program nazwa: '+rm[index].currentprogramname);
   writeln(tf,'------------------------------------------------------------------------------');
   writeln(tf,'Outputs States / Stany wyjsc cyfrowych:');
//   writeln(tf,
   writeln(tf,rm[index].out1n+' :  '+ gbs(rm[index].out1));
   writeln(tf,rm[index].out2n+' :  '+ gbs(rm[index].out2));
   writeln(tf,rm[index].out3n+' :  '+ gbs(rm[index].out3));
   writeln(tf,rm[index].out4n+' :  '+ gbs(rm[index].out4));
   writeln(tf,rm[index].out5n+' :  '+ gbs(rm[index].out5));
   writeln(tf,rm[index].out6n+' :  '+ gbs(rm[index].out6));
   writeln(tf,rm[index].out7n+' :  '+ gbs(rm[index].out7));
   writeln(tf,rm[index].out8n+' :  '+ gbs(rm[index].out8));
   writeln(tf,rm[index].out9n+' :  '+ gbs(rm[index].out9));
   writeln(tf,rm[index].out10n+' :  '+ gbs(rm[index].out10));

   writeln(tf,rm[index].out11n+' :  '+ gbs(rm[index].out11));
   writeln(tf,rm[index].out12n+' :  '+ gbs(rm[index].out12));
   writeln(tf,rm[index].out13n+' :  '+ gbs(rm[index].out13));
   writeln(tf,rm[index].out14n+' :  '+ gbs(rm[index].out14));
   writeln(tf,rm[index].out15n+' :  '+ gbs(rm[index].out15));
   writeln(tf,rm[index].out16n+' :  '+ gbs(rm[index].out16));
   writeln(tf,rm[index].out17n+' :  '+ gbs(rm[index].out17));
   writeln(tf,rm[index].out18n+' :  '+ gbs(rm[index].out18));
   writeln(tf,rm[index].out19n+' :  '+ gbs(rm[index].out19));
   writeln(tf,rm[index].out20n+' :  '+ gbs(rm[index].out20));

   writeln(tf,rm[index].out21n+' :  '+ gbs(rm[index].out21));
   writeln(tf,rm[index].out22n+' :  '+ gbs(rm[index].out22));
   writeln(tf,rm[index].out23n+' :  '+ gbs(rm[index].out23));
   writeln(tf,rm[index].out24n+' :  '+ gbs(rm[index].out24));
{   writeln(tf,rm[index].out25n+' :  '+ gbs(rm[index].out25));
   writeln(tf,rm[index].out26n+' :  '+ gbs(rm[index].out26));
   writeln(tf,rm[index].out27n+' :  '+ gbs(rm[index].out27));
   writeln(tf,rm[index].out28n+' :  '+ gbs(rm[index].out28));
   writeln(tf,rm[index].out29n+' :  '+ gbs(rm[index].out29));
   writeln(tf,rm[index].out30n+' :  '+ gbs(rm[index].out30));

   writeln(tf,rm[index].out31n+' :  '+ gbs(rm[index].out31));
   writeln(tf,rm[index].out32n+' :  '+ gbs(rm[index].out32));
   writeln(tf,rm[index].out33n+' :  '+ gbs(rm[index].out33));
   writeln(tf,rm[index].out34n+' :  '+ gbs(rm[index].out34));
   writeln(tf,rm[index].out35n+' :  '+ gbs(rm[index].out35));
 }
    writeln(tf,'------------------------------------------------------------------------------');
    writeln(tf,'');

if (rm[index].adrh=1) then //Heat manager
      begin
      writeln(tf,'HM Temperatures Measurement / Pomiary temperatur HeatManagera :');
      for i:=0 to 15 do writeln(tf,HADCNames[i]+' :  '+fl(HADC[i])+' [C]');
//binary status for hm

if       boiler_alarm then writeln(tf,'boiler alarm above programmed alarm temperature');
writeln(tf,inttostr(bonfire_stat)+'bonfire heating level 0-7 for binary mode');

if bonfire_sensor_error then writeln(tf,'bonfire sensors error too much different water jacket temperature between two sensors');

writeln(tf,'Recuperator: '+recuperator_status);
if recu_winter then writeln(tf,'Recu Winter')
else writeln(Tf,'Recu Summer Mode');
if not recu_manual_amalva then writeln(tf,'recuperator auto mode for amalva recuperator (managed by internal amalva controler)')
else writeln(tf,'recuperator manual mode for amalva recuperator (by eHouse HeatManager)');
if (went_cooler) then writeln(tf,'water cooler ON for ventilation or recuperation')
else writeln(tf,'water cooler OFF for ventilation or recuperation');
if went_gwc then writeln(tf,'gwc (ground heat exchanger) ON')
else writeln(tf,'gwc (ground heat exchanger) OFF');
if went_aux_gwc_fan then writeln (tf,'auxiliary gwc vetilator / fan ON for ground heat exchanger')
else writeln (tf,'auxiliary gwc vetilator / fan OFF for ground heat exchanger');
if bonfire_dgp then writeln(tf,'bonfire hot air distribution system ENABLED')
else writeln(tf,'bonfire hot air distribution system DISABLED');
if ventilation_on then writeln(tf,'ventilation is currently ON')
else writeln(tf,'ventilation is currently OFF');
if heater_pump then writeln(tf,'pump for heater for ventilation ON')
else writeln(tf,'pump for heater for ventilation OFF');
if (three_ways_cutoff=0) then writeln(tf,'three ways cutoff STOP')
else if (three_ways_cutoff>0) then writeln(tf,'three ways cutoff direction INCREASING level')
else writeln(tf,'three ways cutoff direction DECREASING level');
if solar_pump then writeln(tf,'solar pump ON')
else writeln(tf,'solar pump OFF');
if boiler_on then writeln (tf,'boiler enabled')
else writeln(tf,'boiler disabled');
if boiler_pump then writeln (tf,'boiler pump ON')
else writeln (tf,'boiler pump OFF');
if boiler_fuel_out then writeln(tf,'boiler out of fuel ');
if boiler_power_on then writeln (tf,'boiler power supply ON')
else writeln (tf,'boiler power supply ON');

if boiler_fuel_supply_override then writeln(tf,'boiler fuel supplier override (control by ehouse)')
else  writeln(tf,'boiler fuel supplier controled by boiler controller');
if bonfire_pump then writeln(tf,'bonfire pump ON')
else writeln(tf,'bonfire pump OFF');
writeln (tf,'Recu Speed: '+inttostr(recu_speed));
writeln (tf,'Recu Temperature (for amalva): '+inttostr(recu_temperature)+' [C]');
writeln (tf,'Recu Mode from HeatManager Control Panel eHouse.exe: '+_recu_mode);
//kom_level:integer=0;    //level for bonfire 0-7 the same as bonfire_stat
//kom_stat:integer=0;
writeln (tf,'Ventilation status from HeatManager Control Panel eHouse.exe: '+went);
writeln (tf,'Boiler status from HeatManager Control Panel eHouse.exe: '+koci);
writeln (tf,'Solar status from HeatManager Control Panel eHouse.exe: '+sola);
writeln (tf,'Bonfire status from HeatManager Control Panel eHouse.exe: '+komi);







      end
else
    begin   // not HM
   writeln(tf,'Digital Inputs States / Wejscia cyfrowe stany:');
   writeln(tf,rm[index].int1n+' :  '+ gbs(rm[index].int1));
   writeln(tf,rm[index].int2n+' :  '+ gbs(rm[index].int2));
   writeln(tf,rm[index].int3n+' :  '+ gbs(rm[index].int3));
   writeln(tf,rm[index].int4n+' :  '+ gbs(rm[index].int4));
   writeln(tf,rm[index].int5n+' :  '+ gbs(rm[index].int5));
   writeln(tf,rm[index].int6n+' :  '+ gbs(rm[index].int6));
   writeln(tf,rm[index].int7n+' :  '+ gbs(rm[index].int7));
   writeln(tf,rm[index].int8n+' :  '+ gbs(rm[index].int8));

   writeln(tf,rm[index].in1n+' :  '+ gbs(rm[index].in1));
   writeln(tf,rm[index].in2n+' :  '+ gbs(rm[index].in2));
   writeln(tf,rm[index].in3n+' :  '+ gbs(rm[index].in3));
   writeln(tf,rm[index].in4n+' :  '+ gbs(rm[index].in4));
   writeln(tf,rm[index].in5n+' :  '+ gbs(rm[index].in5));
   writeln(tf,rm[index].in6n+' :  '+ gbs(rm[index].in6));
   writeln(tf,rm[index].in7n+' :  '+ gbs(rm[index].in7));
   writeln(tf,rm[index].in8n+' :  '+ gbs(rm[index].in8));
   writeln(tf,'------------------------------------------------------------------------------');
   writeln(tf);

   writeln(tf,'ADC Measurement for RM / Pomiar Analogowy wejsc:');
   write(tf,'Percent value in reference to RM power supply value');
   writeln(tf,' - Wartosc procentowa w odniesieniu do napiecia zasilania RM');
   writeln(tf,rm[index].adc1n+' :  '+fl(rm[index].adc1)+' [%]');
   writeln(tf,rm[index].adc2n+' :  '+fl(rm[index].adc2)+' [%]');
   writeln(tf,rm[index].adc3n+' :  '+fl(rm[index].adc3)+' [%]');
   writeln(tf,rm[index].adc4n+' :  '+fl(rm[index].adc4)+' [%]');
   writeln(tf,rm[index].adc5n+' :  '+fl(rm[index].adc5)+' [%]');
   writeln(tf,rm[index].adc6n+' :  '+fl(rm[index].adc6)+' [%]');
   writeln(tf,rm[index].adc7n+' :  '+fl(rm[index].adc7)+' [%]');
   writeln(tf,rm[index].adc8n+' :  '+fl(rm[index].adc8)+' [%]');
   writeln(tf);

   writeln(tf,'Inverted Percent value in reference to RM power supply value - odwrocona Wartosc procentowa w odniesieniu do napiecia zasilania RM 100% - x');
   writeln(tf,rm[index].adc1n+' :  '+fl(rm[index].light1)+' [%]');
   writeln(tf,rm[index].adc2n+' :  '+fl(rm[index].light2)+' [%]');
   writeln(tf,rm[index].adc3n+' :  '+fl(rm[index].light3)+' [%]');
   writeln(tf,rm[index].adc4n+' :  '+fl(rm[index].light4)+' [%]');
   writeln(tf,rm[index].adc5n+' :  '+fl(rm[index].light5)+' [%]');
   writeln(tf,rm[index].adc6n+' :  '+fl(rm[index].light6)+' [%]');
   writeln(tf,rm[index].adc7n+' :  '+fl(rm[index].light7)+' [%]');
   writeln(tf,rm[index].adc8n+' :  '+fl(rm[index].light8)+' [%]');
   writeln(tf);
   writeln(tf,'Temperature calculated value - Wartosc obliczona temperatury');
   writeln(tf,rm[index].adc1n+' :  '+fl(rm[index].temp1)+' [C]');
   writeln(tf,rm[index].adc2n+' :  '+fl(rm[index].temp2)+' [C]');
   writeln(tf,rm[index].adc3n+' :  '+fl(rm[index].temp3)+' [C]');
   writeln(tf,rm[index].adc4n+' :  '+fl(rm[index].temp4)+' [C]');
   writeln(tf,rm[index].adc5n+' :  '+fl(rm[index].temp5)+' [C]');
   writeln(tf,rm[index].adc6n+' :  '+fl(rm[index].temp6)+' [C]');
   writeln(tf,rm[index].adc7n+' :  '+fl(rm[index].temp7)+' [C]');
   writeln(tf,rm[index].adc8n+' :  '+fl(rm[index].temp8)+' [C]');


   writeln(tf,'');

   end;

   flush(tf);
   closefile(tf);
   end;
   inc(index);
   end;
end;
///////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
//
// Test saving result for verification ethernet controllers
//
//////////////////////////////////////////////////////////////////////////////
procedure Test_save_eth;
var tf:textfile;
str:string;
i:integer;
ethroommanagerindex:integer;
begin

ethroommanagerindex:=0;
while length(ethrm[ethroommanagerindex].devname)>0 do

begin
if ethroommanagerindex<>commmanagerindex then
  if ethrm[ethroommanagerindex].getnewdata then

   begin
   ethrm[ethroommanagerindex].getnewdata:=false;

   assignfile(tf,path+'logs\'+ethrm[ethroommanagerindex].devname+'_test.txt');
   rewrite(tf);

   writeln(tf,'Device Name / Nazwa urzadzenia: '+ ethrm[ethroommanagerindex].devname);
   writeln(tf,'Device Address / Adres urzadzenia: ('+inttostr(ethrm[ethroommanagerindex].adrh)+','+inttostr(ethrm[ethroommanagerindex].adrl)+')');
   writeln(tf,'Date: '+datetimetostr(ethrm[ethroommanagerindex].datetime));
   writeln(tf,'------------------------------------------------------------------------------');
   writeln(tf,'Current program / biezacy program: '+inttostr(ethrm[ethroommanagerindex].currentprogram));
   writeln(tf,'Current program name / biezacy program nazwa: '+ethrm[ethroommanagerindex].currentprogramname);
   writeln(tf,'------------------------------------------------------------------------------');
   writeln(tf,'Outputs States / Stany wyjsc cyfrowych :');

for i:=0 to 35 do // XDOUTS_COUNT-1 do maximal for dedicated levelmanager
if ((length(ethrm[ethroommanagerindex].doutsnames[i])>0) and (pos('@',ethrm[ethroommanagerindex].doutsnames[i])=0)) then
  if (ethrm[ethroommanagerindex].xdouts[i]) then  writeln(tf,ethrm[ethroommanagerindex].doutsnames[i]+':   1')
  else writeln(tf,ethrm[ethroommanagerindex].doutsnames[i]+':   0');
    writeln(tf,'------------------------------------------------------------------------------');
    writeln(tf,'');


    begin   // not HM
   writeln(tf,'Digital Inputs States / Wejscia cyfrowe stany:');
for i:=0 to 47 do // XDINS_COUNT-1 do maximal for dedicated levelmanager
if ((length(ethrm[ethroommanagerindex].xdinsnames[i])>0) and (pos('@',ethrm[ethroommanagerindex].xdinsnames[i])=0)) then
      if ethrm[ethroommanagerindex].xdins[i] then writeln(tf,ethrm[ethroommanagerindex].xdinsnames[i]+':   1')
      else writeln(tf,ethrm[ethroommanagerindex].xdinsnames[i]+':   0');
   writeln(tf,'------------------------------------------------------------------------------');
   writeln(tf);
   for i:=0 to 55 do ///XROLLERS_COUNT-1 do maximal for dedicated controller

   if ((length(ethrm[ethroommanagerindex].Rollernames[i])>0) and (pos('@',ethrm[ethroommanagerindex].Rollernames[i])=0)) then
        writeln(tf,ethrm[ethroommanagerindex].RollerNames[i]+'  '+inttostr(ethrm[ethroommanagerindex].Rollers[i]));
   writeln(tf);
   writeln(tf,'ADC Measurement for RM / Pomiar Analogowy wejsc:');
   write(tf,'Percent value in reference to RM power supply value');
   writeln(tf,' - Wartosc procentowa w odniesieniu do napiecia zasilania RM');


   writeln(tf);
   for i:=0 to 15 do       //przetworniki                  / ADCs
           if ((length(ethrm[ethroommanagerindex].adcsnames[i])>0) and (pos('@',ethrm[ethroommanagerindex].adcsnames[i])=0)) then
                writeln(tf,ethrm[ethroommanagerindex].adcsnames[i]+'  '+fl(ethrm[ethroommanagerindex].adcs[i])+' [%]');
   writeln(tf);
   writeln(tf,'ADC Measurement Index value [0..1023]');
   writeln(tf,'Pomiary wejsc A/C - index [0..1023]');

   writeln(tf);

   for i:=0 to 15 do       //przetworniki               // ADCs
           if ((length(ethrm[ethroommanagerindex].adcsnames[i])>0) and (pos('@',ethrm[ethroommanagerindex].adcsnames[i])=0)) then
                writeln(tf,ethrm[ethroommanagerindex].adcsnames[i]+'  '+inttostr(ethrm[ethroommanagerindex].adcsind[i]) +' [index 0..1023]');

   writeln(tf);
   writeln(tf,'Temperature calculated value - Wartosc obliczona temperatury');
   for i:=0 to 15 do       //przetworniki       // ADCs
   if ((length(ethrm[ethroommanagerindex].adcsnames[i])>0) and (pos('@',ethrm[ethroommanagerindex].adcsnames[i])=0)) then
        writeln(tf,ethrm[ethroommanagerindex].adcsnames[i]+'  '+fl(ethrm[ethroommanagerindex].temps[i]) +' [C]');
   writeln(tf);
   writeln(tf,'Temperature mcp9700 calculated value - Wartosc obliczona temperatury');
   for i:=0 to 15 do       //przetworniki       //ADCs
   if ((length(ethrm[ethroommanagerindex].adcsnames[i])>0) and (pos('@',ethrm[ethroommanagerindex].adcsnames[i])=0)) then
        writeln(tf,ethrm[ethroommanagerindex].adcsnames[i]+'  '+fl(ethrm[ethroommanagerindex].tempsMCP9700[i]) +' [C]');

   writeln(tf);
   writeln(tf,'Temperature mcp9701 calculated value - Wartosc obliczona temperatury');
   for i:=0 to 15 do       //przetworniki       //ADCs
   if ((length(ethrm[ethroommanagerindex].adcsnames[i])>0) and (pos('@',ethrm[ethroommanagerindex].adcsnames[i])=0)) then
        writeln(tf,ethrm[ethroommanagerindex].adcsnames[i]+'  '+fl(ethrm[ethroommanagerindex].tempsMCP9701[i]) +' [C]');


   writeln(tf,'');

   end;

   flush(tf);
   closefile(tf);
   end;
   inc(ethroommanagerindex);
   end;
end;
///////////////////////////////////////////////////////////////////////////////////
procedure Test_save_commmanager;
var tf:textfile;
str:string;
i,commanagerindex:integer;

begin
commanagerindex:=commmanagerindex;

begin
if ethrm[commanagerindex].getnewdata then

   begin
   ethrm[commanagerindex].getnewdata:=false;

   assignfile(tf,path+'logs\'+ethrm[commanagerindex].devname+'_test.txt');
   rewrite(tf);

   writeln(tf,'Device Name / Nazwa urzadzenia: '+ ethrm[commanagerindex].devname);
   writeln(tf,'Device Address / Adres urzadzenia: ('+inttostr(ethrm[commanagerindex].adrh)+','+inttostr(ethrm[commanagerindex].adrl)+')');
   writeln(tf,'Date: '+datetimetostr(ethrm[commanagerindex].datetime));
   writeln(tf,'------------------------------------------------------------------------------');
   writeln(tf,'Current program / biezacy program: '+inttostr(ethrm[commanagerindex].currentprogram));
   writeln(tf,'Current program name / biezacy program nazwa: '+ethrm[commanagerindex].currentprogramname);
   writeln(tf,'------------------------------------------------------------------------------');
   writeln(tf,'Extended Outputs States / Stany wyjsc cyfrowych rozszerzonych:');

for i:=0 to 79 do // XDOUTS_COUNT-1 do maximal for dedicated levelmanager
  if ((length(ethrm[commmanagerindex].xdoutsnames[i])>0) and (pos('@',ethrm[commmanagerindex].xdoutsnames[i])=0)) then
    if (ethrm[commmanagerindex].xdouts[i]) then  writeln(tf,ethrm[commanagerindex].xdoutsnames[i]+':   1')
    else writeln(tf,ethrm[commanagerindex].xdoutsnames[i]+':   0');
    writeln(tf,'------------------------------------------------------------------------------');
    writeln(tf,'');


    begin   // 
   writeln(tf,'Extended Digital Inputs States / Wejscia cyfrowe rozszerzone stany:');
for i:=0 to 47 do // XDINS_COUNT-1 do maximal for dedicated levelmanager
  if ((length(ethrm[commmanagerindex].xdinsnames[i])>0) and (pos('@',ethrm[commmanagerindex].xdinsnames[i])=0)) then
      if ethrm[commmanagerindex].xdins[i] then writeln(tf,ethrm[commmanagerindex].xdinsnames[i]+':   1')
      else writeln(tf,ethrm[commmanagerindex].xdinsnames[i]+':   0');
   writeln(tf,'------------------------------------------------------------------------------');
   writeln(tf);
   writeln(tf,'Alarm Inputs States / Alarm stany:');
for i:=0 to 47 do // XDINS_COUNT-1 do maximal for dedicated levelmanager
  if ((length(ethrm[commmanagerindex].xdinsnames[i])>0) and (pos('@',ethrm[commmanagerindex].xdinsnames[i])=0)) then
      if ethrm[commmanagerindex].xalarms[i] then writeln(tf,ethrm[commmanagerindex].xdinsnames[i]+':   1')
;//      else writeln(tf,ethrm[commmanagerindex].xdinsnames[i]+':   0');
   writeln(tf,'------------------------------------------------------------------------------');
   writeln(tf);
   writeln(tf,'Warning Inputs States / Ostrzezenie stany:');
for i:=0 to 47 do // XDINS_COUNT-1 do maximal for dedicated levelmanager
  if ((length(ethrm[commmanagerindex].xdinsnames[i])>0) and (pos('@',ethrm[commmanagerindex].xdinsnames[i])=0)) then
      if ethrm[commmanagerindex].xwarnings[i] then writeln(tf,ethrm[commmanagerindex].xdinsnames[i]+':   1')
  ;//    else writeln(tf,ethrm[commmanagerindex].xdinsnames[i]+':   0');
   writeln(tf,'------------------------------------------------------------------------------');
   writeln(tf);

   writeln(tf,'Monitoring Inputs States / Monitoring stany:');
for i:=0 to 47 do // XDINS_COUNT-1 do maximal for dedicated levelmanager
  if ((length(ethrm[commmanagerindex].xdinsnames[i])>0) and (pos('@',ethrm[commmanagerindex].xdinsnames[i])=0)) then
      if ethrm[commmanagerindex].xmonitorings[i] then writeln(tf,ethrm[commmanagerindex].xdinsnames[i]+':   1')
;//      else writeln(tf,ethrm[commmanagerindex].xdinsnames[i]+':   0');
   writeln(tf,'------------------------------------------------------------------------------');
   writeln(tf);


   for i:=0 to 55 do ///XROLLERS_COUNT-1 do maximal for dedicated controller
     if ((length(ethrm[commmanagerindex].rollernames[i])>0) and (pos('@',ethrm[commmanagerindex].rollernames[i])=0)) then
        writeln(tf,ethrm[commmanagerindex].RollerNames[i]+'  '+inttostr(ethrm[commmanagerindex].Rollers[i]));
   writeln(tf);
   writeln(tf,'ADC Measurement for RM / Pomiar Analogowy wejsc:');
   write(tf,'Percent value in reference to RM power supply value');
   writeln(tf,' - Wartosc procentowa w odniesieniu do napiecia zasilania RM');


   writeln(tf);
   for i:=0 to 15 do       //przetworniki //ADCs
     if ((length(ethrm[commmanagerindex].adcsnames[i])>0) and (pos('@',ethrm[commmanagerindex].adcsnames[i])=0)) then
        writeln(tf,ethrm[commmanagerindex].adcsnames[i]+'  '+fl(ethrm[commmanagerindex].adcs[i])+' [%]');
   writeln(tf);
   writeln(tf,'ADC Measurement Index value [0..1023]');
   writeln(tf,'Pomiary wejsc A/C - index [0..1023]');
   writeln(tf);
   for i:=0 to 15 do       //przetworniki       //ADCs
        if ((length(ethrm[commmanagerindex].adcsnames[i])>0) and (pos('@',ethrm[commmanagerindex].adcsnames[i])=0)) then
        writeln(tf,ethrm[commmanagerindex].adcsnames[i]+'  '+inttostr(ethrm[commmanagerindex].adcsind[i]) +' [index 0..1023]');
   writeln(tf);
   writeln(tf,'Temperature calculated value - Wartosc obliczona temperatury');
   for i:=0 to 15 do       //przetworniki       //ADCs
        if ((length(ethrm[commmanagerindex].adcsnames[i])>0) and (pos('@',ethrm[commmanagerindex].adcsnames[i])=0)) then
        writeln(tf,ethrm[commmanagerindex].adcsnames[i]+'  '+fl(ethrm[commmanagerindex].temps[i]) +' [C]');
   writeln(tf);
   writeln(tf,'Temperature mcp9700 calculated value - Wartosc obliczona temperatury');
   for i:=0 to 15 do       //przetworniki       //ADCs
   if ((length(ethrm[commmanagerindex].adcsnames[i])>0) and (pos('@',ethrm[commmanagerindex].adcsnames[i])=0)) then
        writeln(tf,ethrm[commmanagerindex].adcsnames[i]+'  '+fl(ethrm[commmanagerindex].tempsMCP9700[i]) +' [C]');
   writeln(tf);
   writeln(tf,'Temperature mcp9701 calculated value - Wartosc obliczona temperatury');
   for i:=0 to 15 do       //przetworniki       //ADCs
   if ((length(ethrm[commmanagerindex].adcsnames[i])>0) and (pos('@',ethrm[commmanagerindex].adcsnames[i])=0)) then
        writeln(tf,ethrm[commmanagerindex].adcsnames[i]+'  '+fl(ethrm[commmanagerindex].tempsMCP9701[i]) +' [C]');
   writeln(tf,'');
   end;
   flush(tf);
   closefile(tf);
   end;
   inc(commanagerindex);
   end;
end;
//
// helper functions
//
//////////////////////////////////////////////////////////////////////////////////
//
// return index of RM by name case insensitive
// -1 if not found
//
////////////////////////////////////////////////////////////////////////////////
function RMDeviceIndexByName(str:string):integer;
var
i:integer;
begin
i:=0;
result:=-1;
while length(rm[i].devname)>0 do
           begin
           if comparetext(str,rm[i].devname)=0 then
               begin
               result:=i;
               break;
               end;
           inc(i);
           end;


end;
////////////////////////////////////////////////////////////////////////////////
function ETHRMDeviceIndexByName(str:string):integer;
var
i:integer;
begin
i:=0;
result:=-1;
while length(ethrm[i].devname)>0 do
           begin
           if comparetext(str,ethrm[i].devname)=0 then
               begin
               result:=i;
               break;
               end;
           inc(i);
           end;
end;
/////////////////////////////////////////////////////////////////////////////////
//
// Found output name by name and return state of RM index
//
/////////////////////////////////////////////////////////////////////////////////
function RMGetOutputState(index:integer;OutputName:string):boolean;
var i:integer;
begin
i:=index;
result:=false;
if index<0 then exit;
if comparetext(OutputName,rm[i].out1n)=0 then result:=rm[i].out1;
if comparetext(OutputName,rm[i].out2n)=0 then result:=rm[i].out2;
if comparetext(OutputName,rm[i].out3n)=0 then result:=rm[i].out3;
if comparetext(OutputName,rm[i].out4n)=0 then result:=rm[i].out4;
if comparetext(OutputName,rm[i].out5n)=0 then result:=rm[i].out5;
if comparetext(OutputName,rm[i].out6n)=0 then result:=rm[i].out6;
if comparetext(OutputName,rm[i].out7n)=0 then result:=rm[i].out7;
if comparetext(OutputName,rm[i].out8n)=0 then result:=rm[i].out8;
if comparetext(OutputName,rm[i].out9n)=0 then result:=rm[i].out9;
if comparetext(OutputName,rm[i].out10n)=0 then result:=rm[i].out10;

if comparetext(OutputName,rm[i].out11n)=0 then result:=rm[i].out11;
if comparetext(OutputName,rm[i].out12n)=0 then result:=rm[i].out12;
if comparetext(OutputName,rm[i].out13n)=0 then result:=rm[i].out13;
if comparetext(OutputName,rm[i].out14n)=0 then result:=rm[i].out14;
if comparetext(OutputName,rm[i].out15n)=0 then result:=rm[i].out15;
if comparetext(OutputName,rm[i].out16n)=0 then result:=rm[i].out16;
if comparetext(OutputName,rm[i].out17n)=0 then result:=rm[i].out17;
if comparetext(OutputName,rm[i].out18n)=0 then result:=rm[i].out18;
if comparetext(OutputName,rm[i].out19n)=0 then result:=rm[i].out19;
if comparetext(OutputName,rm[i].out20n)=0 then result:=rm[i].out20;

if comparetext(OutputName,rm[i].out21n)=0 then result:=rm[i].out21;
if comparetext(OutputName,rm[i].out22n)=0 then result:=rm[i].out22;
if comparetext(OutputName,rm[i].out23n)=0 then result:=rm[i].out23;
if comparetext(OutputName,rm[i].out24n)=0 then result:=rm[i].out24;
if comparetext(OutputName,rm[i].out25n)=0 then result:=rm[i].out25;
if comparetext(OutputName,rm[i].out26n)=0 then result:=rm[i].out26;
if comparetext(OutputName,rm[i].out27n)=0 then result:=rm[i].out27;
if comparetext(OutputName,rm[i].out28n)=0 then result:=rm[i].out28;
if comparetext(OutputName,rm[i].out29n)=0 then result:=rm[i].out29;
if comparetext(OutputName,rm[i].out30n)=0 then result:=rm[i].out30;

if comparetext(OutputName,rm[i].out31n)=0 then result:=rm[i].out31;
if comparetext(OutputName,rm[i].out32n)=0 then result:=rm[i].out32;
if comparetext(OutputName,rm[i].out33n)=0 then result:=rm[i].out33;
if comparetext(OutputName,rm[i].out34n)=0 then result:=rm[i].out34;
if comparetext(OutputName,rm[i].out35n)=0 then result:=rm[i].out35;

end;
/////////////////////////////////////////////////////////////////////////////////
//
// Found output name by index and return state of RM index
//
/////////////////////////////////////////////////////////////////////////////////
function RMGetOutputStateNr(index:integer;OutputNr:integer):boolean;
var i:integer;
begin
i:=index;

result:=false;
if index<0 then exit;
case OutputNr of
1:      result:=rm[i].out1;
2:      result:=rm[i].out2;
3:      result:=rm[i].out3;
4:      result:=rm[i].out4;
5:      result:=rm[i].out5;
6:      result:=rm[i].out6;
7:      result:=rm[i].out7;
8:      result:=rm[i].out8;
9:      result:=rm[i].out9;
10:     result:=rm[i].out10;

11:     result:=rm[i].out11;
12:     result:=rm[i].out12;
13:     result:=rm[i].out13;
14:     result:=rm[i].out14;
15:     result:=rm[i].out15;
16:     result:=rm[i].out16;
17:     result:=rm[i].out17;
18:     result:=rm[i].out18;
19:     result:=rm[i].out19;
20:     result:=rm[i].out20;

21:     result:=rm[i].out21;
22:     result:=rm[i].out22;
23:     result:=rm[i].out23;
24:     result:=rm[i].out24;
25:     result:=rm[i].out25;
26:     result:=rm[i].out26;
27:     result:=rm[i].out27;
28:     result:=rm[i].out28;
29:     result:=rm[i].out29;
30:     result:=rm[i].out30;

31:     result:=rm[i].out31;
32:     result:=rm[i].out32;
33:     result:=rm[i].out33;
34:     result:=rm[i].out34;
35:     result:=rm[i].out35;
end;
end;

////////////////////////////////////////////////////////////////////////////////
//
// Get input state (search by name) of RM found by index
// default false if not found
//
//
/////////////////////////////////////////////////////////////////////////////////
function RMGetInputState(index:integer;InputName:string):boolean;
var i:integer;
OutputName:string;
begin
OutputName:=InputName;
i:=index;
result:=false;
if (index<0) then exit;
if comparetext(OutputName,rm[i].int1n)=0 then result:=rm[i].int1;
if comparetext(OutputName,rm[i].int2n)=0 then result:=rm[i].int2;
if comparetext(OutputName,rm[i].int3n)=0 then result:=rm[i].int3;
if comparetext(OutputName,rm[i].int4n)=0 then result:=rm[i].int4;
if comparetext(OutputName,rm[i].int5n)=0 then result:=rm[i].int5;
if comparetext(OutputName,rm[i].int6n)=0 then result:=rm[i].int6;
if comparetext(OutputName,rm[i].int7n)=0 then result:=rm[i].int7;
if comparetext(OutputName,rm[i].int8n)=0 then result:=rm[i].int8;

if comparetext(OutputName,rm[i].in1n)=0 then result:=rm[i].in1;
if comparetext(OutputName,rm[i].in2n)=0 then result:=rm[i].in2;
if comparetext(OutputName,rm[i].in3n)=0 then result:=rm[i].in3;
if comparetext(OutputName,rm[i].in4n)=0 then result:=rm[i].in4;
if comparetext(OutputName,rm[i].in5n)=0 then result:=rm[i].in5;
if comparetext(OutputName,rm[i].in6n)=0 then result:=rm[i].in6;
if comparetext(OutputName,rm[i].in7n)=0 then result:=rm[i].in7;
if comparetext(OutputName,rm[i].in8n)=0 then result:=rm[i].in8;

end;
////////////////////////////////////////////////////////////////////////////////
//
// Get input state (search by index of input 1..16) of RM found by index
// default false if not found
//
//
/////////////////////////////////////////////////////////////////////////////////
function RMGetInputStateNr(index:integer;InputNr:integer):boolean;
var i:integer;
begin
i:=index;
result:=false;
if index<0 then exit;
case InputNr of
1:      result:=rm[i].int1;
2:      result:=rm[i].int2;
3:      result:=rm[i].int3;
4:      result:=rm[i].int4;
5:      result:=rm[i].int5;
6:      result:=rm[i].int6;
7:      result:=rm[i].int7;
8:      result:=rm[i].int8;
9:      result:=rm[i].in1;
10:     result:=rm[i].in2;
11:     result:=rm[i].in3;
12:     result:=rm[i].in4;
13:     result:=rm[i].in5;
14:     result:=rm[i].in6;
15:     result:=rm[i].in7;
16:     result:=rm[i].in8;
end;
end;

////////////////////////////////////////////////////////////////////////////////
//
// Get temperature (search by name) of RM found by index
// default false if not found
//
//
/////////////////////////////////////////////////////////////////////////////////
function RMGetTemp(index:integer;InputName:string):double;
var i:integer;
begin
i:=index;
if index<0 then exit;
result:=-255;
if comparetext(InputName,rm[i].adc1n)=0 then result:=rm[i].temp1;
if comparetext(InputName,rm[i].adc2n)=0 then result:=rm[i].temp2;
if comparetext(InputName,rm[i].adc3n)=0 then result:=rm[i].temp3;
if comparetext(InputName,rm[i].adc4n)=0 then result:=rm[i].temp4;
if comparetext(InputName,rm[i].adc5n)=0 then result:=rm[i].temp5;
if comparetext(InputName,rm[i].adc6n)=0 then result:=rm[i].temp6;
if comparetext(InputName,rm[i].adc7n)=0 then result:=rm[i].temp7;
if comparetext(InputName,rm[i].adc8n)=0 then result:=rm[i].temp8;
if (rm[index].adrh=1) then
        result:=HMGetTemp(InputName);
end;
////////////////////////////////////////////////////////////////////////////////
//
// Get temperature (search by index 1..8) of RM found by index
// default false if not found
//
//
/////////////////////////////////////////////////////////////////////////////////
function RMGetTempNr(index:integer;InputNr:integer):double;
var i:integer;
begin
i:=index;
result:=-255;
if index<0 then exit;
case InputNr of
1:      result:=rm[i].temp1;
2:      result:=rm[i].temp2;
3:      result:=rm[i].temp3;
4:      result:=rm[i].temp4;
5:      result:=rm[i].temp5;
6:      result:=rm[i].temp6;
7:      result:=rm[i].temp7;
8:      result:=rm[i].temp8;
end;
if (rm[index].adrh=1) then
        result:=HMGetTempNr(InputNr);
end;
////////////////////////////////////////////////////////////////////////////////
//
// Get HM temperature (Temp sensor search by name)
//
//
//
/////////////////////////////////////////////////////////////////////////////////
function HMGetTemp(InputName:string):double;
var i:integer;
begin
i:=0;
result:=-255;
for i:=0 to 15 do
        begin
        if comparetext(InputName,HADCNames[i])=0 then
                begin
                result:=HADC[i];
                break;
                end;
        end;
end;
////////////////////////////////////////////////////////////////////////////////
/// get temperature for heat manager by index (1..16)
//
function HMGetTempNr(InputNr:integer):double;
var i:integer;
begin
i:=0;
result:=-255;
if ((InputNr<=16) and (InputNr>0)) then                result:=HADC[InputNr-1];
end;
////////////////////////////////////////////////////////////////////////////////
//
// Get percent value comparing to power suply (search by name) of RM found by index
// default false if not found
//
//
/////////////////////////////////////////////////////////////////////////////////
function RMGetInvPercent(index:integer;InputName:string):double;
var i:integer;
begin
i:=index;
result:=-255;
if index<0 then exit;
if comparetext(InputName,rm[i].adc1n)=0 then result:=rm[i].light1;
if comparetext(InputName,rm[i].adc2n)=0 then result:=rm[i].light2;
if comparetext(InputName,rm[i].adc3n)=0 then result:=rm[i].light3;
if comparetext(InputName,rm[i].adc4n)=0 then result:=rm[i].light4;
if comparetext(InputName,rm[i].adc5n)=0 then result:=rm[i].light5;
if comparetext(InputName,rm[i].adc6n)=0 then result:=rm[i].light6;
if comparetext(InputName,rm[i].adc7n)=0 then result:=rm[i].light7;
if comparetext(InputName,rm[i].adc8n)=0 then result:=rm[i].light8;
if (rm[index].adrh=1) then
        result:=HMGetTemp(InputName);
end;
////////////////////////////////////////////////////////////////////////////////
//
// Get RM index by dev address
// if not found returns -1
//
////////////////////////////////////////////////////////////////////////////////
function GetRMIndexFromAddress(adrh:integer;adrl:integer):integer;
var index:integer;
begin
index:=0;
result:=-1;
while length(RM[index].devname)>0 do
  begin
  if ((adrh=RM[index].adrh) and (adrl=RM[index].adrl)) then
        begin
        result:=index;
        break;
        end;
  inc(index);
  end;
end;
////////////////////////////////////////////////////////////////////////////////
//
// Get percent value comparing to power suply (search by output index) of RM found by index
// default -255 if not found
//
//
/////////////////////////////////////////////////////////////////////////////////

function RMGetInvPercentNr(index:integer;InputNr:integer):double;
var i:integer;
begin
i:=index;
result:=-255;
if index<0 then exit;
case  InputNr of
1:      result:=rm[i].light1;
2:      result:=rm[i].light2;
3:      result:=rm[i].light3;
4:      result:=rm[i].light4;
5:      result:=rm[i].light5;
6:      result:=rm[i].light6;
7:      result:=rm[i].light7;
8:      result:=rm[i].light8;
end;
if (rm[index].adrh=1) then
        result:=HMGetTempNr(InputNr);
end;

////////////////////////////////////////////////////////////////////////////////
//
// Get percent value comparing to power suply (search by name) of RM found by index
// default false if not found
//
//
/////////////////////////////////////////////////////////////////////////////////
function RMGetPercent(index:integer;InputName:string):double;
var i:integer;
begin
i:=index;
result:=-255;
if index<0 then exit;
if comparetext(InputName,rm[i].adc1n)=0 then result:=rm[i].adc1;
if comparetext(InputName,rm[i].adc2n)=0 then result:=rm[i].adc2;
if comparetext(InputName,rm[i].adc3n)=0 then result:=rm[i].adc3;
if comparetext(InputName,rm[i].adc4n)=0 then result:=rm[i].adc4;
if comparetext(InputName,rm[i].adc5n)=0 then result:=rm[i].adc5;
if comparetext(InputName,rm[i].adc6n)=0 then result:=rm[i].adc6;
if comparetext(InputName,rm[i].adc7n)=0 then result:=rm[i].adc7;
if comparetext(InputName,rm[i].adc8n)=0 then result:=rm[i].adc8;
if (rm[index].adrh=1) then
        result:=HMGetTemp(InputName);
end;
/////////////////////////////////////////////////////////////////////////////////
//
// get percent value comparing to power suply (search by index of rm and index of inputnr)
//
////////////////////////////////////////////////////////////////////////////////////
function RMGetPercentNr(index:integer;InputNr:integer):double;
var i:integer;
begin
i:=index;
result:=-255;
if index<0 then exit;
case InputNr of
1:      result:=rm[i].adc1;
2:      result:=rm[i].adc2;
3:      result:=rm[i].adc3;
4:      result:=rm[i].adc4;
5:      result:=rm[i].adc5;
6:      result:=rm[i].adc6;
7:      result:=rm[i].adc7;
9:      result:=rm[i].adc8;
end;
if (rm[index].adrh=1) then
        result:=HMGetTempNr(InputNr);
end;

////////////////////////////////////////////////////////////////////////////////
//
// Get Output state input data: RoomManager name, Output Name to check
//
/////////////////////////////////////////////////////////////////////////////////
function RMGetDeviceOutputState(Devname:string;OutputName:string):boolean;
var index:integer;
begin
result:=false;
index:=RMDeviceIndexByName(DevName);
if (index>=0) then
        result:=RMGetOutputState(index,OutputName);
end;
////////////////////////////////////////////////////////////////////////////////
//
// Get Input state input data: RoomManager name, Input Name to check
//
/////////////////////////////////////////////////////////////////////////////////
function RMGetDeviceInputState(Devname:string;InputName:string):boolean;
var index:integer;
begin
result:=false;
index:=RMDeviceIndexByName(DevName);
if (index>=0) then
        result:=RMGetInputState(index,InputName);
end;
/////////////////////////////////////////////////////////////////////////////////
//
// Timer for refreshing data in case of old ehouse 1 instalation
//
////////////////////////////////////////////////////////////////////////////////





procedure TForm1.Timer1Timer(Sender: TObject);
var tf:textfile;
begin
if (filesystem_status) then
begin
update_status;
update_panel;
update_panel_tcp;
Test_save;
Test_save_commmanager;
Test_save_eth;

try
assignfile(tf,path+'logs\log-analizer.stp');      //notify WDT that application working correctly using stampfile "logs\log-analizer.stp"
rewrite(tf);
writeln(tf,'1');
finally;
closefile(tf);
end;
end;
end;
/////////////////////////////////////////////////////////////////////////
// any of program button click event handler - run propper event for program change
//
procedure TForm1.Program1Click(Sender: TObject);
var
cl:tcolor;
str:string;
int:integer;
begin
str:=stringreplace((sender as tpanel).name,'program','',[rfignorecase]);
int:=chk_int(str)-1;
if (deviceindex>=0) then
        begin
        if (rm[deviceindex].adrh<>1) then runevent(2,chk_int(str),255,255,255,255,(sender as tpanel).caption)     //other controllers event code 0x02
        else runevent($aa,int,255,255,255,255,(sender as tpanel).caption);              //HeatManager event code 0xaa
        end
else
if ethdeviceindex>=0 then
        runevent(2,int,255,255,255,255,(sender as tpanel).caption);     //other controllers event code 0x02

cl:=(sender as tpanel).color;
(sender as tpanel).Bevelinner:=bvLowered;
(sender as tpanel).BevelOuter:=bvLowered;
(sender as tpanel).color:=clltgray;
(sender as tpanel).refresh;
form1.refresh;
sleep(200);
(sender as tpanel).color:=cl;
(sender as tpanel).Bevelinner:=bvRaised;
(sender as tpanel).BevelOuter:=bvRaised;
(sender as tpanel).refresh;
form1.refresh;

end;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// run event if ehouse1version then put events in event queue on pc %ehouse/emails/ directory which will be performed by ehouse.exe application
// otherwise try sending via tcp ip directly to controller or via commmanager for ehouse1 controlers under commmanager supervision
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
procedure RunEvent(eventcode:integer;arg1:integer;arg2:integer;arg3:integer;arg4:integer;arg5:integer;str:string);
var tf:textfile;
devname:string;
adrh,adrl:integer;
begin
evnt[2]:=eventcode;                                //event code
evnt[3]:=arg1;                                     //arg 1
evnt[4]:=arg2;
evnt[5]:=arg3;
evnt[6]:=arg4;
evnt[7]:=arg5;
evnt[8]:=255;
evnt[9]:=255;
statusstr:='';
if (deviceindex>=0) then
        begin
        devname:=rm[deviceindex].devname;
        adrh:=rm[deviceindex].adrh;
        adrl:=rm[deviceindex].adrl;
        evnt[0]:=adrh;  // address h - direct event
        evnt[1]:=adrl;  // address l - direct event
        admem(devname+': '+str);
        if (not ehouse1version) then    //submit via tcp ip via commmanager
                begin
                form1.berkeley.address:=CommanagerAddress;
                form1.berkeley.port:=strtoint(CommanagerPort);
                sendsoc(0);
                end;
        end;

if (ethdeviceindex>=0) then
        begin
        devname:=ethrm[ethdeviceindex].devname;
        adrh:=ethrm[ethdeviceindex].adrh;
        adrl:=ethrm[ethdeviceindex].adrl;
        evnt[0]:=adrh;  // address h - direct event
        evnt[1]:=adrl;  // address l - direct event
                admem(devname+': '+str);
        if (not ehouse1version) then    //submit via tcp directly to ethernet controller
                begin
                form1.berkeley.address:='192.168.'+inttostr(adrh)+'.'+inttostr(adrl);
                form1.berkeley.port:=strtoint(CommanagerPort);
                sendsoc(0);
                end;
        end;
{DONT MODIFY FILE with EVENTS OTHERWISE SYSTEM can drop the events or ehouse.exe could crash}
if (ehouse1version) then       //ehouse 1 version put to /emails/ directory for eHouse.exe application
        begin
        assignfile(tf,remotepath+'emails\'+devname+' - '+str+'.run');
        rewrite(tf);
        if (eventcode=1) then writeln(tf,devname+'; '+str+'<-(toggle)') //dont touch
        else writeln(tf,devname+'; '+str); //dont touch
        writeln(tf);writeln(tf);writeln(tf);writeln(tf);writeln(tf);writeln(tf);writeln(tf); //dont touch
        writeln(tf,'Direct Event Dont change this file'); ///Dont touch direct event
        writeln(tf,inttostr(adrh));  // address h - direct event
        writeln(tf,inttostr(adrl));  // address l - direct event
        writeln(tf,inttostr(eventcode));                                //event code
        writeln(tf,inttostr(arg1));                                     //arg 1
        writeln(tf,inttostr(arg2));
        writeln(tf,inttostr(arg3));
        writeln(tf,inttostr(arg4));
        writeln(tf,inttostr(arg5));
        writeln(tf,inttostr(255));
        writeln(tf,inttostr(255));
        flush(tf);
        closefile(tf);
        end;

end;

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
{procedure RunEventTCP(eventcode:integer;arg1:integer;arg2:integer;arg3:integer;arg4:integer;arg5:integer;str:string);
var tf:textfile;
begin
assignfile(tf,remotepath+'emails\'+ethrm[ethdeviceindex].devname+' - '+str+'.run');//+computername);
rewrite(tf);
if (eventcode=1) then writeln(tf,ethrm[ethdeviceindex].devname+'; '+str+'<-(toggle)') //dont touch
else writeln(tf,ethrm[ethdeviceindex].devname+'; '+str); //dont touch
writeln(tf);writeln(tf);writeln(tf);writeln(tf);writeln(tf);writeln(tf);writeln(tf); //dont touch
writeln(tf,'Direct Event Dont change this file'); ///Dont touch direct event
writeln(tf,inttostr(ethrm[ethdeviceindex].adrh));  // address h - direct event
writeln(tf,inttostr(ethrm[ethdeviceindex].adrl));  // address l - direct event

writeln(tf,inttostr(eventcode));                                //event code
writeln(tf,inttostr(arg1));                                     //arg 1
writeln(tf,inttostr(arg2));
writeln(tf,inttostr(arg3));
writeln(tf,inttostr(arg4));
writeln(tf,inttostr(arg5));
writeln(tf,inttostr(255));
writeln(tf,inttostr(255));
flush(tf);
closefile(tf);
//copyfile(Pchar(path+'emails\'+Rm[deviceindex].devname+' - '+str+'.'+computername),Pchar(path+'emails\'+Rm[deviceindex].devname+' - '+str+'.run'),false); //copy file to avoid multiple file access issues
//deletefile(path+'emails\'+Rm[deviceindex].devname+' - '+str+'.'+computername);          //delete oryginal
end;

 }
/////////////////////////////////////////////////////////////////////////////////
//
// Output buttons event handler - run proper event for choosen output
//
/////////////////////////////////////////////////////////////////////////////////
procedure TForm1.output1Click(Sender: TObject);
var
cl:tcolor;
str:string;
int:integer;
begin
str:=stringreplace((sender as tpanel).name,'output','',[rfignorecase]);
int:=chk_int(str);
int:=(int-1);
if (ethdeviceindex>=0) then
        begin
        berkeley.Address:='192.168.'+inttostr(ethrm[ethdeviceindex].adrh)+'.'+inttostr(ethrm[ethdeviceindex].adrl);
        berkeley.host:='192.168.'+inttostr(ethrm[ethdeviceindex].adrh)+'.'+inttostr(ethrm[ethdeviceindex].adrl);
        runevent($21,int,2,255,255,255,(sender as tpanel).caption);
        end
else
  if (rm[ethdeviceindex].adrh<>1) then runevent(1,chk_int(str),2,255,255,255,(sender as tpanel).caption)
     else
     begin
        case int of                                                                     //for HM no direct assignment events to outputs
                                                                                        //so it make some heatmanager events
        1: runevent(ord('h'),ord('m'),255,255,255,255,(sender as tpanel).caption);
        2: runevent(ord('h'),ord('+'),255,255,255,255,(sender as tpanel).caption);
        3: runevent(ord('h'),ord('-'),255,255,255,255,(sender as tpanel).caption);
        4: runevent(ord('h'),ord('t'),255,255,255,255,(sender as tpanel).caption);
        5: runevent(ord('h'),ord('d'),255,255,255,255,(sender as tpanel).caption);
        6: runevent(ord('h'),ord('o'),255,255,255,255,(sender as tpanel).caption);
        7: runevent(ord('h'),ord('e'),255,255,255,255,(sender as tpanel).caption);
        8: runevent(ord('h'),ord('k'),255,255,255,255,(sender as tpanel).caption);
        //9: runevent(ord('h'),ord('c'),255,255,255,255,(sender as tpanel).caption);
        //10: runevent(ord('h'),ord('c'),255,255,255,255,(sender as tpanel).caption);
        //11: runevent(ord('h'),ord('c'),255,255,255,255,(sender as tpanel).caption);
        //12: runevent(ord('h'),ord('c'),255,255,255,255,(sender as tpanel).caption);
        13: runevent(ord('h'),ord('g'),255,255,255,255,(sender as tpanel).caption);
        //14: runevent(ord('h'),ord('c'),255,255,255,255,(sender as tpanel).caption);
        //15: runevent(ord('h'),ord('c'),255,255,255,255,(sender as tpanel).caption);
        16: runevent(ord('h'),ord('k'),255,255,255,255,(sender as tpanel).caption);
        17: runevent(ord('h'),ord('W'),255,255,255,255,(sender as tpanel).caption);
        //18: runevent(ord('h'),ord('c'),255,255,255,255,(sender as tpanel).caption);
        //19: runevent(ord('h'),ord('c'),255,255,255,255,(sender as tpanel).caption);
        //20: runevent(ord('h'),ord('c'),255,255,255,255,(sender as tpanel).caption);
        //21: runevent(ord('h'),ord('c'),255,255,255,255,(sender as tpanel).caption);
        //22: runevent(ord('h'),ord('c'),255,255,255,255,(sender as tpanel).caption);
        //23: runevent(ord('h'),ord('c'),255,255,255,255,(sender as tpanel).caption);
        //24: runevent(ord('h'),ord('c'),255,255,255,255,(sender as tpanel).caption);
        end;
   end;

cl:=(sender as tpanel).color;                           //act as pressing button event for tpanel
(sender as tpanel).Bevelinner:=bvLowered;
(sender as tpanel).BevelOuter:=bvLowered;
(sender as tpanel).color:=clltgray;
(sender as tpanel).refresh;
form1.refresh;
sleep(200);
(sender as tpanel).color:=cl;
(sender as tpanel).Bevelinner:=bvRaised;
(sender as tpanel).BevelOuter:=bvRaised;
(sender as tpanel).refresh;
form1.refresh;

end;
////////////////////////////////////////////////////////////////////////////////
function fl(st:double):string;
var tmp:integer;
tmd:double;
begin
tmp:=round(st*10);
tmd:=tmp;
result:=(floattostr(tmd/10));

end;

//Update panel form data change colors for outputs, values for measurement inputs , labels, heat manager status data
procedure update_panel;
var i:integer;
str:string;
begin
if (deviceindex<0) then exit;
if rm[deviceindex].out1 then form1.output1.color:=oncolor
else  form1.output1.color:=offcolor;
if rm[deviceindex].out2 then form1.output2.color:=oncolor
else  form1.output2.color:=offcolor;
if rm[deviceindex].out3 then form1.output3.color:=oncolor
else  form1.output3.color:=offcolor;
if rm[deviceindex].out4 then form1.output4.color:=oncolor
else  form1.output4.color:=offcolor;
if rm[deviceindex].out5 then form1.output5.color:=oncolor
else  form1.output5.color:=offcolor;
if rm[deviceindex].out6 then form1.output6.color:=oncolor
else  form1.output6.color:=offcolor;
if rm[deviceindex].out7 then form1.output7.color:=oncolor
else  form1.output7.color:=offcolor;
if rm[deviceindex].out8 then form1.output8.color:=oncolor
else  form1.output8.color:=offcolor;
if rm[deviceindex].out9 then form1.output9.color:=oncolor
else  form1.output9.color:=offcolor;
if rm[deviceindex].out10 then form1.output10.color:=oncolor
else  form1.output10.color:=offcolor;
if rm[deviceindex].out11 then form1.output11.color:=oncolor
else  form1.output11.color:=offcolor;
if rm[deviceindex].out12 then form1.output12.color:=oncolor
else  form1.output12.color:=offcolor;
if rm[deviceindex].out13 then form1.output13.color:=oncolor
else  form1.output13.color:=offcolor;
if rm[deviceindex].out14 then form1.output14.color:=oncolor
else  form1.output14.color:=offcolor;
if rm[deviceindex].out15 then form1.output15.color:=oncolor
else  form1.output15.color:=offcolor;
if rm[deviceindex].out16 then form1.output16.color:=oncolor
else  form1.output16.color:=offcolor;
if rm[deviceindex].out17 then form1.output17.color:=oncolor
else  form1.output17.color:=offcolor;
if rm[deviceindex].out18 then form1.output18.color:=oncolor
else  form1.output18.color:=offcolor;
if rm[deviceindex].out19 then form1.output19.color:=oncolor
else  form1.output19.color:=offcolor;
if rm[deviceindex].out20 then form1.output20.color:=oncolor
else  form1.output20.color:=offcolor;
if rm[deviceindex].out21 then form1.output21.color:=oncolor
else  form1.output21.color:=offcolor;
if rm[deviceindex].out22 then form1.output22.color:=oncolor
else  form1.output22.color:=offcolor;
if rm[deviceindex].out23 then form1.output23.color:=oncolor
else  form1.output23.color:=offcolor;
if rm[deviceindex].out24 then form1.output24.color:=oncolor
else  form1.output24.color:=offcolor;

{if rm[deviceindex].out25 then form1.output25.color:=oncolor
else  form1.output25.color:=offcolor;
if rm[deviceindex].out26 then form1.output26.color:=oncolor
else  form1.output26.color:=offcolor;
if rm[deviceindex].out27 then form1.output27.color:=oncolor
else  form1.output27.color:=offcolor;
if rm[deviceindex].out28 then form1.output28.color:=oncolor
else  form1.output28.color:=offcolor;
if rm[deviceindex].out29 then form1.output29.color:=oncolor
else  form1.output29.color:=offcolor;
if rm[deviceindex].out30 then form1.output30.color:=oncolor
else  form1.output30.color:=offcolor;
if rm[deviceindex].out31 then form1.output31.color:=oncolor
else  form1.output31.color:=offcolor;
if rm[deviceindex].out32 then form1.output32.color:=oncolor
else  form1.output32.color:=offcolor;
if rm[deviceindex].out33 then form1.output33.color:=oncolor
else  form1.output33.color:=offcolor;
if rm[deviceindex].out34 then form1.output34.color:=oncolor
else  form1.output34.color:=offcolor;
if rm[deviceindex].out35 then form1.output35.color:=oncolor
else  form1.output35.color:=offcolor;
}
i:=0;
str:=stringreplace(LabelNames[i],'[C]','  '+fl(rm[deviceindex].temp1)+' C',[rfignorecase]);
str:=stringreplace(str,'[%]','  '+fl(rm[deviceindex].adc1)+' %',[rfignorecase]);
str:=stringreplace(str,'[-%]','  '+fl(rm[deviceindex].light1)+' %',[rfignorecase]);
form1.label1.caption:=str;inc(i);

str:=stringreplace(LabelNames[i],'[C]','  '+fl(rm[deviceindex].temp2)+' C',[rfignorecase]);
str:=stringreplace(str,'[%]','  '+fl(rm[deviceindex].adc2)+' %',[rfignorecase]);
str:=stringreplace(str,'[-%]','  '+fl(rm[deviceindex].light2)+' %',[rfignorecase]);
form1.label2.caption:=str;inc(i);

str:=stringreplace(LabelNames[i],'[C]','  '+fl(rm[deviceindex].temp3)+' C',[rfignorecase]);
str:=stringreplace(str,'[%]','  '+fl(rm[deviceindex].adc3)+' %',[rfignorecase]);
str:=stringreplace(str,'[-%]','  '+fl(rm[deviceindex].light3)+' %',[rfignorecase]);
form1.label3.caption:=str;inc(i);

str:=stringreplace(LabelNames[i],'[C]','  '+fl(rm[deviceindex].temp4)+' C',[rfignorecase]);
str:=stringreplace(str,'[%]','  '+fl(rm[deviceindex].adc4)+' %',[rfignorecase]);
str:=stringreplace(str,'[-%]','  '+fl(rm[deviceindex].light4)+' %',[rfignorecase]);
form1.label4.caption:=str;inc(i);

str:=stringreplace(LabelNames[i],'[C]','  '+fl(rm[deviceindex].temp5)+' C',[rfignorecase]);
str:=stringreplace(str,'[%]','  '+fl(rm[deviceindex].adc5)+' %',[rfignorecase]);
str:=stringreplace(str,'[-%]','  '+fl(rm[deviceindex].light5)+' %',[rfignorecase]);
form1.label5.caption:=str;inc(i);

str:=stringreplace(LabelNames[i],'[C]','  '+fl(rm[deviceindex].temp6)+' C',[rfignorecase]);
str:=stringreplace(str,'[%]','  '+fl(rm[deviceindex].adc6)+' %',[rfignorecase]);
str:=stringreplace(str,'[-%]','  '+fl(rm[deviceindex].light6)+' %',[rfignorecase]);
form1.label6.caption:=str;inc(i);


str:=stringreplace(LabelNames[i],'[C]','  '+fl(rm[deviceindex].temp7)+' C',[rfignorecase]);
str:=stringreplace(str,'[%]','  '+fl(rm[deviceindex].adc7)+' %',[rfignorecase]);
str:=stringreplace(str,'[-%]','  '+fl(rm[deviceindex].light7)+' %',[rfignorecase]);
form1.label7.caption:=str;inc(i);

str:=stringreplace(LabelNames[i],'[C]','  '+fl(rm[deviceindex].temp8)+' C',[rfignorecase]);
str:=stringreplace(str,'[%]','  '+fl(rm[deviceindex].adc8)+' %',[rfignorecase]);
str:=stringreplace(str,'[-%]','  '+fl(rm[deviceindex].light8)+' %',[rfignorecase]);
form1.label8.caption:=str;inc(i);

str:=stringreplace(LabelNames[i],'[C]','  '+fl(rm[deviceindex].temp9)+' C',[rfignorecase]);
str:=stringreplace(str,'[%]','  '+fl(rm[deviceindex].adc9)+' %',[rfignorecase]);
str:=stringreplace(str,'[-%]','  '+fl(rm[deviceindex].light9)+' %',[rfignorecase]);
form1.label9.caption:=str;inc(i);


str:=stringreplace(LabelNames[i],'[C]','  '+fl(rm[deviceindex].temp10)+' C',[rfignorecase]);
str:=stringreplace(str,'[%]','  '+fl(rm[deviceindex].adc10)+' %',[rfignorecase]);
str:=stringreplace(str,'[-%]','  '+fl(rm[deviceindex].light10)+' %',[rfignorecase]);
form1.label10.caption:=str;inc(i);

str:=stringreplace(LabelNames[i],'[C]','  '+fl(rm[deviceindex].temp11)+' C',[rfignorecase]);
str:=stringreplace(str,'[%]','  '+fl(rm[deviceindex].adc11)+' %',[rfignorecase]);
str:=stringreplace(str,'[-%]','  '+fl(rm[deviceindex].light11)+' %',[rfignorecase]);
form1.label11.caption:=str;inc(i);

str:=stringreplace(LabelNames[i],'[C]','  '+fl(rm[deviceindex].temp12)+' C',[rfignorecase]);
str:=stringreplace(str,'[%]','  '+fl(rm[deviceindex].adc12)+' %',[rfignorecase]);
str:=stringreplace(str,'[-%]','  '+fl(rm[deviceindex].light12)+' %',[rfignorecase]);
form1.label12.caption:=str;inc(i);

str:=stringreplace(LabelNames[i],'[C]','  '+fl(rm[deviceindex].temp13)+' C',[rfignorecase]);
str:=stringreplace(str,'[%]','  '+fl(rm[deviceindex].adc13)+' %',[rfignorecase]);
str:=stringreplace(str,'[-%]','  '+fl(rm[deviceindex].light13)+' %',[rfignorecase]);
form1.label13.caption:=str;inc(i);

str:=stringreplace(LabelNames[i],'[C]','  '+fl(rm[deviceindex].temp14)+' C',[rfignorecase]);
str:=stringreplace(str,'[%]','  '+fl(rm[deviceindex].adc14)+' %',[rfignorecase]);
str:=stringreplace(str,'[-%]','  '+fl(rm[deviceindex].light14)+' %',[rfignorecase]);
form1.label14.caption:=str;inc(i);

str:=stringreplace(LabelNames[i],'[C]','  '+fl(rm[deviceindex].temp15)+' C',[rfignorecase]);
str:=stringreplace(str,'[%]','  '+fl(rm[deviceindex].adc15)+' %',[rfignorecase]);
str:=stringreplace(str,'[-%]','  '+fl(rm[deviceindex].light15)+' %',[rfignorecase]);
form1.label15.caption:=str;inc(i);

str:=stringreplace(LabelNames[i],'[C]','  '+fl(rm[deviceindex].temp16)+' C',[rfignorecase]);
str:=stringreplace(str,'[%]','  '+fl(rm[deviceindex].adc16)+' %',[rfignorecase]);
str:=stringreplace(str,'[-%]','  '+fl(rm[deviceindex].light16)+' %',[rfignorecase]);
form1.label16.caption:=str;inc(i);
//-----------------------------------------------------------------------
bonfire_status:=stringreplace(bonfire_status,'bonfire','',[rfignorecase]);
solar_status:=stringreplace(solar_status,'solar','',[rfignorecase]);
boiler_status:=stringreplace(boiler_status,'boiler','',[rfignorecase]);
str:=stringreplace(LabelNames[i],'%StatusBonfire%',bonfire_status,[rfignorecase]);
str:=stringreplace(str,'%StatusBoiler%',boiler_status,[rfignorecase]);
str:=stringreplace(str,'%StatusSolar%',solar_status,[rfignorecase]);
str:=stringreplace(str,'%StatusVentilation%',recuperator_status,[rfignorecase]);
str:=stringreplace(str,'%CurrentProgram%',inttostr(RM[deviceindex].currentprogram),[rfignorecase]);
str:=stringreplace(str,'%CurrentProgramName%',RM[deviceindex].currentprogramname,[rfignorecase]);
form1.label17.caption:=str;inc(i);

str:=stringreplace(LabelNames[i],'%StatusBonfire%',bonfire_status,[rfignorecase]);
str:=stringreplace(str,'%StatusBoiler%',boiler_status,[rfignorecase]);
str:=stringreplace(str,'%StatusSolar%',solar_status,[rfignorecase]);
str:=stringreplace(str,'%StatusVentilation%',recuperator_status,[rfignorecase]);
str:=stringreplace(str,'%CurrentProgram%',inttostr(RM[deviceindex].currentprogram),[rfignorecase]);
str:=stringreplace(str,'%CurrentProgramName%',RM[deviceindex].currentprogramname,[rfignorecase]);
form1.label18.caption:=str;inc(i);

str:=stringreplace(LabelNames[i],'%StatusBonfire%',bonfire_status,[rfignorecase]);
str:=stringreplace(str,'%StatusBoiler%',boiler_status,[rfignorecase]);
str:=stringreplace(str,'%StatusSolar%',solar_status,[rfignorecase]);
str:=stringreplace(str,'%StatusVentilation%',recuperator_status,[rfignorecase]);
str:=stringreplace(str,'%CurrentProgram%',inttostr(RM[deviceindex].currentprogram),[rfignorecase]);
str:=stringreplace(str,'%CurrentProgramName%',RM[deviceindex].currentprogramname,[rfignorecase]);
form1.label19.caption:=str;inc(i);

str:=stringreplace(LabelNames[i],'%StatusBonfire%',bonfire_status,[rfignorecase]);
str:=stringreplace(str,'%StatusBoiler%',boiler_status,[rfignorecase]);
str:=stringreplace(str,'%StatusSolar%',solar_status,[rfignorecase]);
str:=stringreplace(str,'%StatusVentilation%',recuperator_status,[rfignorecase]);
str:=stringreplace(str,'%CurrentProgram%',inttostr(RM[deviceindex].currentprogram),[rfignorecase]);
str:=stringreplace(str,'%CurrentProgramName%',RM[deviceindex].currentprogramname,[rfignorecase]);
form1.label20.caption:=str;inc(i);

str:=stringreplace(LabelNames[i],'%StatusBonfire%',bonfire_status,[rfignorecase]);
str:=stringreplace(str,'%StatusBoiler%',boiler_status,[rfignorecase]);
str:=stringreplace(str,'%StatusSolar%',solar_status,[rfignorecase]);
str:=stringreplace(str,'%StatusVentilation%',recuperator_status,[rfignorecase]);
str:=stringreplace(str,'%CurrentProgram%',inttostr(RM[deviceindex].currentprogram),[rfignorecase]);
str:=stringreplace(str,'%CurrentProgramName%',RM[deviceindex].currentprogramname,[rfignorecase]);
form1.label21.caption:=str;inc(i);

str:=stringreplace(LabelNames[i],'%StatusBonfire%',bonfire_status,[rfignorecase]);
str:=stringreplace(str,'%StatusBoiler%',boiler_status,[rfignorecase]);
str:=stringreplace(str,'%StatusSolar%',solar_status,[rfignorecase]);
str:=stringreplace(str,'%StatusVentilation%',recuperator_status,[rfignorecase]);
str:=stringreplace(str,'%CurrentProgram%',inttostr(RM[deviceindex].currentprogram),[rfignorecase]);
str:=stringreplace(str,'%CurrentProgramName%',RM[deviceindex].currentprogramname,[rfignorecase]);
form1.label22.caption:=str;inc(i);

str:=stringreplace(LabelNames[i],'%StatusBonfire%',bonfire_status,[rfignorecase]);
str:=stringreplace(str,'%StatusBoiler%',boiler_status,[rfignorecase]);
str:=stringreplace(str,'%StatusSolar%',solar_status,[rfignorecase]);
str:=stringreplace(str,'%StatusVentilation%',recuperator_status,[rfignorecase]);
str:=stringreplace(str,'%CurrentProgram%',inttostr(RM[deviceindex].currentprogram),[rfignorecase]);
str:=stringreplace(str,'%CurrentProgramName%',RM[deviceindex].currentprogramname,[rfignorecase]);
form1.label23.caption:=str;inc(i);

str:=stringreplace(LabelNames[i],'%StatusBonfire%',bonfire_status,[rfignorecase]);
str:=stringreplace(str,'%StatusBoiler%',boiler_status,[rfignorecase]);
str:=stringreplace(str,'%StatusSolar%',solar_status,[rfignorecase]);
str:=stringreplace(str,'%StatusVentilation%',recuperator_status,[rfignorecase]);
str:=stringreplace(str,'%CurrentProgram%',inttostr(RM[deviceindex].currentprogram),[rfignorecase]);
str:=stringreplace(str,'%CurrentProgramName%',RM[deviceindex].currentprogramname,[rfignorecase]);
form1.label24.caption:=str;inc(i);

str:=stringreplace(LabelNames[i],'%StatusBonfire%',bonfire_status,[rfignorecase]);
str:=stringreplace(str,'%StatusBoiler%',boiler_status,[rfignorecase]);
str:=stringreplace(str,'%StatusSolar%',solar_status,[rfignorecase]);
str:=stringreplace(str,'%StatusVentilation%',recuperator_status,[rfignorecase]);
str:=stringreplace(str,'%CurrentProgram%',inttostr(RM[deviceindex].currentprogram),[rfignorecase]);
str:=stringreplace(str,'%CurrentProgramName%',RM[deviceindex].currentprogramname,[rfignorecase]);
form1.label25.caption:=str;inc(i);


//          writeln(tf,'Bonfire: ');
//  writeln(tf,'Boiler: ');
//  writeln(tf,'Vent: ');
//  writeln(tf,'Solar: ')
//bonfire_status:string;  //status of bonfire for HeatManager
//boiler_status:string;   //status of boiler for HM
//Solar_status:string;    //status of solar system
//recuperator_status:string;// status of recuperation, ventilation, air heating



//if (rm[deviceindex].adrh<>1) then
        caption:='eHouse Control Panel: '+rm[deviceindex].devname+' '+formatdatetime('yyyy-mm-dd, hh:nn:ss',rm[deviceindex].datetime)  //set caption of main form do RoomManager Name - pokazuje w naglówku formularza nazwê roommanagera
        ;
        admem('');
//else
//    form1.caption:=trim(recuperator_status)+' '
//+trim(bonfire_status)+' '  //status of bonfire for HeatManager
//+trim(boiler_status)+' '   //status of boiler for HM
//+trim(Solar_status)+' '    //status of solar system
//+formatdatetime({'yyyy-mm-dd, }//'hh:nn:ss',rm[deviceindex].datetime)+' '+ rm[deviceindex].devname+' ';// status of recuperation, ventilation, air heating
  //set caption of main form do RoomManager Name - pokazuje w naglówku formularza nazwê roommanagera
//form1.refresh;
//}
end;
///////////////////////////////////////////////////////////////////////////////
//
// update panel form data set outputs buttons colors, label text, adc values
//
////////////////////////////////////////////////////////////////////////////////

procedure update_panel_tcp;
var i:integer;
str:string;
var deviceindex:integer;
begin
if ethdeviceindex<0 then exit;
deviceindex:=ethdeviceindex;
i:=0;
if ethrm[ethdeviceindex].xdouts[i] then form1.output1.color:=oncolor
else  form1.output1.color:=offcolor;
inc(i);
if ethrm[ethdeviceindex].xdouts[i] then form1.output2.color:=oncolor
else  form1.output2.color:=offcolor;
inc(i);
if ethrm[ethdeviceindex].xdouts[i] then form1.output3.color:=oncolor
else  form1.output3.color:=offcolor;
inc(i);
if ethrm[ethdeviceindex].xdouts[i] then form1.output4.color:=oncolor
else  form1.output4.color:=offcolor;
inc(i);
if ethrm[ethdeviceindex].xdouts[i] then form1.output5.color:=oncolor
else  form1.output5.color:=offcolor;
inc(i);
if ethrm[ethdeviceindex].xdouts[i] then form1.output6.color:=oncolor
else  form1.output6.color:=offcolor;
inc(i);
if ethrm[ethdeviceindex].xdouts[i] then form1.output7.color:=oncolor
else  form1.output7.color:=offcolor;
inc(i);
if ethrm[ethdeviceindex].xdouts[i] then form1.output8.color:=oncolor
else  form1.output8.color:=offcolor;
inc(i);
if ethrm[ethdeviceindex].xdouts[i] then form1.output9.color:=oncolor
else  form1.output9.color:=offcolor;
inc(i);
if ethrm[ethdeviceindex].xdouts[i] then form1.output10.color:=oncolor
else  form1.output10.color:=offcolor;
inc(i);
if ethrm[ethdeviceindex].xdouts[i] then form1.output11.color:=oncolor
else  form1.output11.color:=offcolor;
inc(i);
if ethrm[ethdeviceindex].xdouts[i] then form1.output12.color:=oncolor
else  form1.output12.color:=offcolor;
inc(i);
if ethrm[ethdeviceindex].xdouts[i] then form1.output13.color:=oncolor
else  form1.output13.color:=offcolor;
inc(i);
if ethrm[ethdeviceindex].xdouts[i] then form1.output14.color:=oncolor
else  form1.output14.color:=offcolor;
inc(i);
if ethrm[ethdeviceindex].xdouts[i] then form1.output15.color:=oncolor
else  form1.output15.color:=offcolor;
inc(i);
if ethrm[ethdeviceindex].xdouts[i] then form1.output16.color:=oncolor
else  form1.output16.color:=offcolor;
inc(i);
if ethrm[ethdeviceindex].xdouts[i] then form1.output17.color:=oncolor
else  form1.output17.color:=offcolor;
inc(i);
if ethrm[ethdeviceindex].xdouts[i] then form1.output18.color:=oncolor
else  form1.output18.color:=offcolor;
inc(i);
if ethrm[ethdeviceindex].xdouts[i] then form1.output19.color:=oncolor
else  form1.output19.color:=offcolor;
inc(i);
if ethrm[ethdeviceindex].xdouts[i] then form1.output20.color:=oncolor
else  form1.output20.color:=offcolor;
inc(i);
if ethrm[ethdeviceindex].xdouts[i] then form1.output21.color:=oncolor
else  form1.output21.color:=offcolor;
inc(i);
if ethrm[ethdeviceindex].xdouts[i] then form1.output22.color:=oncolor
else  form1.output22.color:=offcolor;
inc(i);
if ethrm[ethdeviceindex].xdouts[i] then form1.output23.color:=oncolor
else  form1.output23.color:=offcolor;
inc(i);
if ethrm[ethdeviceindex].xdouts[i] then form1.output24.color:=oncolor
else  form1.output24.color:=offcolor;

{inc(i);
if ethrm[ethdeviceindex].xdouts[i]  then form1.output25.color:=oncolor
else  form1.output25.color:=offcolor;
inc(i);
if ethrm[ethdeviceindex].xdouts[i] then form1.output26.color:=oncolor
else  form1.output26.color:=offcolor;
inc(i);
if ethrm[ethdeviceindex].xdouts[i] then form1.output27.color:=oncolor
else  form1.output27.color:=offcolor;
inc(i);
if ethrm[ethdeviceindex].xdouts[i] then form1.output28.color:=oncolor
else  form1.output28.color:=offcolor;
inc(i);
if ethrm[ethdeviceindex].xdouts[i] then form1.output29.color:=oncolor
else  form1.output29.color:=offcolor;
inc(i);
if ethrm[ethdeviceindex].xdouts[i] then form1.output30.color:=oncolor
else  form1.output30.color:=offcolor;
inc(i);
if ethrm[ethdeviceindex].xdouts[i] then form1.output31.color:=oncolor
else  form1.output31.color:=offcolor;
inc(i);
if ethrm[ethdeviceindex].xdouts[i] then form1.output32.color:=oncolor
else  form1.output32.color:=offcolor;
inc(i);
if ethrm[ethdeviceindex].xdouts[i] then form1.output33.color:=oncolor
else  form1.output33.color:=offcolor;
inc(i);
if ethrm[ethdeviceindex].xdouts[i] then form1.output34.color:=oncolor
else  form1.output34.color:=offcolor;
inc(i);
if ethrm[ethdeviceindex].xdouts[i] then form1.output35.color:=oncolor
else  form1.output35.color:=offcolor;
}
i:=0;
str:=stringreplace(LabelNames[i],'[C]','  '+fl(ethrm[deviceindex].temps[i])+' C',[rfignorecase]);
str:=stringreplace(str,'[%]','  '+fl(ethrm[deviceindex].adcs[i])+' %',[rfignorecase]);
str:=stringreplace(str,'[-%]','  '+fl(100-ethrm[deviceindex].adcs[i])+' %',[rfignorecase]);
str:=stringreplace(str,'[MCP9700]','  '+fl(ethrm[deviceindex].tempsMCP9700[i])+' C',[rfignorecase]);
str:=stringreplace(str,'[MCP9701]','  '+fl(ethrm[deviceindex].tempsMCP9701[i])+' C',[rfignorecase]);
str:=stringreplace(str,'[]','  '+fl(ethrm[deviceindex].adcsind[i])+' ',[rfignorecase]);
form1.label1.caption:=str;inc(i);

str:=stringreplace(LabelNames[i],'[C]','  '+fl(ethrm[deviceindex].temps[i])+' C',[rfignorecase]);
str:=stringreplace(str,'[%]','  '+fl(ethrm[deviceindex].adcs[i])+' %',[rfignorecase]);
str:=stringreplace(str,'[-%]','  '+fl(100-ethrm[deviceindex].adcs[i])+' %',[rfignorecase]);
str:=stringreplace(str,'[MCP9700]','  '+fl(ethrm[deviceindex].tempsMCP9700[i])+' C',[rfignorecase]);
str:=stringreplace(str,'[MCP9701]','  '+fl(ethrm[deviceindex].tempsMCP9701[i])+' C',[rfignorecase]);
str:=stringreplace(str,'[]','  '+fl(ethrm[deviceindex].adcsind[i])+' ',[rfignorecase]);

form1.label2.caption:=str;inc(i);

str:=stringreplace(LabelNames[i],'[C]','  '+fl(ethrm[deviceindex].temps[i])+' C',[rfignorecase]);
str:=stringreplace(str,'[%]','  '+fl(ethrm[deviceindex].adcs[i])+' %',[rfignorecase]);
str:=stringreplace(str,'[-%]','  '+fl(100-ethrm[deviceindex].adcs[i])+' %',[rfignorecase]);
str:=stringreplace(str,'[MCP9700]','  '+fl(ethrm[deviceindex].tempsMCP9700[i])+' C',[rfignorecase]);
str:=stringreplace(str,'[MCP9701]','  '+fl(ethrm[deviceindex].tempsMCP9701[i])+' C',[rfignorecase]);
str:=stringreplace(str,'[]','  '+fl(ethrm[deviceindex].adcsind[i])+' ',[rfignorecase]);
form1.label3.caption:=str;inc(i);

str:=stringreplace(LabelNames[i],'[C]','  '+fl(ethrm[deviceindex].temps[i])+' C',[rfignorecase]);
str:=stringreplace(str,'[%]','  '+fl(ethrm[deviceindex].adcs[i])+' %',[rfignorecase]);
str:=stringreplace(str,'[-%]','  '+fl(100-ethrm[deviceindex].adcs[i])+' %',[rfignorecase]);
str:=stringreplace(str,'[MCP9700]','  '+fl(ethrm[deviceindex].tempsMCP9700[i])+' C',[rfignorecase]);
str:=stringreplace(str,'[MCP9701]','  '+fl(ethrm[deviceindex].tempsMCP9701[i])+' C',[rfignorecase]);
str:=stringreplace(str,'[]','  '+fl(ethrm[deviceindex].adcsind[i])+' ',[rfignorecase]);
form1.label4.caption:=str;inc(i);

str:=stringreplace(LabelNames[i],'[C]','  '+fl(ethrm[deviceindex].temps[i])+' C',[rfignorecase]);
str:=stringreplace(str,'[%]','  '+fl(ethrm[deviceindex].adcs[i])+' %',[rfignorecase]);
str:=stringreplace(str,'[-%]','  '+fl(100-ethrm[deviceindex].adcs[i])+' %',[rfignorecase]);
str:=stringreplace(str,'[MCP9700]','  '+fl(ethrm[deviceindex].tempsMCP9700[i])+' C',[rfignorecase]);
str:=stringreplace(str,'[MCP9701]','  '+fl(ethrm[deviceindex].tempsMCP9701[i])+' C',[rfignorecase]);
str:=stringreplace(str,'[]','  '+fl(ethrm[deviceindex].adcsind[i])+' ',[rfignorecase]);
form1.label5.caption:=str;inc(i);

str:=stringreplace(LabelNames[i],'[C]','  '+fl(ethrm[deviceindex].temps[i])+' C',[rfignorecase]);
str:=stringreplace(str,'[%]','  '+fl(ethrm[deviceindex].adcs[i])+' %',[rfignorecase]);
str:=stringreplace(str,'[-%]','  '+fl(100-ethrm[deviceindex].adcs[i])+' %',[rfignorecase]);
str:=stringreplace(str,'[MCP9700]','  '+fl(ethrm[deviceindex].tempsMCP9700[i])+' C',[rfignorecase]);
str:=stringreplace(str,'[MCP9701]','  '+fl(ethrm[deviceindex].tempsMCP9701[i])+' C',[rfignorecase]);
str:=stringreplace(str,'[]','  '+fl(ethrm[deviceindex].adcsind[i])+' ',[rfignorecase]);
form1.label6.caption:=str;inc(i);


str:=stringreplace(LabelNames[i],'[C]','  '+fl(ethrm[deviceindex].temps[i])+' C',[rfignorecase]);
str:=stringreplace(str,'[%]','  '+fl(ethrm[deviceindex].adcs[i])+' %',[rfignorecase]);
str:=stringreplace(str,'[-%]','  '+fl(100-ethrm[deviceindex].adcs[i])+' %',[rfignorecase]);
str:=stringreplace(str,'[MCP9700]','  '+fl(ethrm[deviceindex].tempsMCP9700[i])+' C',[rfignorecase]);
str:=stringreplace(str,'[MCP9701]','  '+fl(ethrm[deviceindex].tempsMCP9701[i])+' C',[rfignorecase]);
str:=stringreplace(str,'[]','  '+fl(ethrm[deviceindex].adcsind[i])+' ',[rfignorecase]);
form1.label7.caption:=str;inc(i);

str:=stringreplace(LabelNames[i],'[C]','  '+fl(ethrm[deviceindex].temps[i])+' C',[rfignorecase]);
str:=stringreplace(str,'[%]','  '+fl(ethrm[deviceindex].adcs[i])+' %',[rfignorecase]);
str:=stringreplace(str,'[-%]','  '+fl(100-ethrm[deviceindex].adcs[i])+' %',[rfignorecase]);
str:=stringreplace(str,'[MCP9700]','  '+fl(ethrm[deviceindex].tempsMCP9700[i])+' C',[rfignorecase]);
str:=stringreplace(str,'[MCP9701]','  '+fl(ethrm[deviceindex].tempsMCP9701[i])+' C',[rfignorecase]);
str:=stringreplace(str,'[]','  '+fl(ethrm[deviceindex].adcsind[i])+' ',[rfignorecase]);
form1.label8.caption:=str;inc(i);

str:=stringreplace(LabelNames[i],'[C]','  '+fl(ethrm[deviceindex].temps[i])+' C',[rfignorecase]);
str:=stringreplace(str,'[%]','  '+fl(ethrm[deviceindex].adcs[i])+' %',[rfignorecase]);
str:=stringreplace(str,'[-%]','  '+fl(100-ethrm[deviceindex].adcs[i])+' %',[rfignorecase]);
str:=stringreplace(str,'[MCP9700]','  '+fl(ethrm[deviceindex].tempsMCP9700[i])+' C',[rfignorecase]);
str:=stringreplace(str,'[MCP9701]','  '+fl(ethrm[deviceindex].tempsMCP9701[i])+' C',[rfignorecase]);
str:=stringreplace(str,'[]','  '+fl(ethrm[deviceindex].adcsind[i])+' ',[rfignorecase]);
form1.label9.caption:=str;inc(i);


str:=stringreplace(LabelNames[i],'[C]','  '+fl(ethrm[deviceindex].temps[i])+' C',[rfignorecase]);
str:=stringreplace(str,'[%]','  '+fl(ethrm[deviceindex].adcs[i])+' %',[rfignorecase]);
str:=stringreplace(str,'[-%]','  '+fl(100-ethrm[deviceindex].adcs[i])+' %',[rfignorecase]);
str:=stringreplace(str,'[MCP9700]','  '+fl(ethrm[deviceindex].tempsMCP9700[i])+' C',[rfignorecase]);
str:=stringreplace(str,'[MCP9701]','  '+fl(ethrm[deviceindex].tempsMCP9701[i])+' C',[rfignorecase]);
str:=stringreplace(str,'[]','  '+fl(ethrm[deviceindex].adcsind[i])+' ',[rfignorecase]);
form1.label10.caption:=str;inc(i);

str:=stringreplace(LabelNames[i],'[C]','  '+fl(ethrm[deviceindex].temps[i])+' C',[rfignorecase]);
str:=stringreplace(str,'[%]','  '+fl(ethrm[deviceindex].adcs[i])+' %',[rfignorecase]);
str:=stringreplace(str,'[-%]','  '+fl(100-ethrm[deviceindex].adcs[i])+' %',[rfignorecase]);
str:=stringreplace(str,'[MCP9700]','  '+fl(ethrm[deviceindex].tempsMCP9700[i])+' C',[rfignorecase]);
str:=stringreplace(str,'[MCP9701]','  '+fl(ethrm[deviceindex].tempsMCP9701[i])+' C',[rfignorecase]);
str:=stringreplace(str,'[]','  '+fl(ethrm[deviceindex].adcsind[i])+' ',[rfignorecase]);
form1.label11.caption:=str;inc(i);

str:=stringreplace(LabelNames[i],'[C]','  '+fl(ethrm[deviceindex].temps[i])+' C',[rfignorecase]);
str:=stringreplace(str,'[%]','  '+fl(ethrm[deviceindex].adcs[i])+' %',[rfignorecase]);
str:=stringreplace(str,'[-%]','  '+fl(100-ethrm[deviceindex].adcs[i])+' %',[rfignorecase]);
str:=stringreplace(str,'[MCP9700]','  '+fl(ethrm[deviceindex].tempsMCP9700[i])+' C',[rfignorecase]);
str:=stringreplace(str,'[MCP9701]','  '+fl(ethrm[deviceindex].tempsMCP9701[i])+' C',[rfignorecase]);
str:=stringreplace(str,'[]','  '+fl(ethrm[deviceindex].adcsind[i])+' ',[rfignorecase]);
form1.label12.caption:=str;inc(i);

str:=stringreplace(LabelNames[i],'[C]','  '+fl(ethrm[deviceindex].temps[i])+' C',[rfignorecase]);
str:=stringreplace(str,'[%]','  '+fl(ethrm[deviceindex].adcs[i])+' %',[rfignorecase]);
str:=stringreplace(str,'[-%]','  '+fl(100-ethrm[deviceindex].adcs[i])+' %',[rfignorecase]);
str:=stringreplace(str,'[MCP9700]','  '+fl(ethrm[deviceindex].tempsMCP9700[i])+' C',[rfignorecase]);
str:=stringreplace(str,'[MCP9701]','  '+fl(ethrm[deviceindex].tempsMCP9701[i])+' C',[rfignorecase]);
str:=stringreplace(str,'[]','  '+fl(ethrm[deviceindex].adcsind[i])+' ',[rfignorecase]);
form1.label13.caption:=str;inc(i);

str:=stringreplace(LabelNames[i],'[C]','  '+fl(ethrm[deviceindex].temps[i])+' C',[rfignorecase]);
str:=stringreplace(str,'[%]','  '+fl(ethrm[deviceindex].adcs[i])+' %',[rfignorecase]);
str:=stringreplace(str,'[-%]','  '+fl(100-ethrm[deviceindex].adcs[i])+' %',[rfignorecase]);
str:=stringreplace(str,'[MCP9700]','  '+fl(ethrm[deviceindex].tempsMCP9700[i])+' C',[rfignorecase]);
str:=stringreplace(str,'[MCP9701]','  '+fl(ethrm[deviceindex].tempsMCP9701[i])+' C',[rfignorecase]);
str:=stringreplace(str,'[]','  '+fl(ethrm[deviceindex].adcsind[i])+' ',[rfignorecase]);
str:=stringreplace(str,'%CurrentProgram%',inttostr(RM[deviceindex].currentprogram),[rfignorecase]);
str:=stringreplace(str,'%CurrentProgramName%',RM[deviceindex].currentprogramname,[rfignorecase]);

form1.label14.caption:=str;inc(i);

str:=stringreplace(LabelNames[i],'[C]','  '+fl(ethrm[deviceindex].temps[i])+' C',[rfignorecase]);
str:=stringreplace(str,'[%]','  '+fl(ethrm[deviceindex].adcs[i])+' %',[rfignorecase]);
str:=stringreplace(str,'[-%]','  '+fl(100-ethrm[deviceindex].adcs[i])+' %',[rfignorecase]);
str:=stringreplace(str,'[MCP9700]','  '+fl(ethrm[deviceindex].tempsMCP9700[i])+' C',[rfignorecase]);
str:=stringreplace(str,'[MCP9701]','  '+fl(ethrm[deviceindex].tempsMCP9701[i])+' C',[rfignorecase]);
str:=stringreplace(str,'[]','  '+fl(ethrm[deviceindex].adcsind[i])+' ',[rfignorecase]);
str:=stringreplace(str,'%CurrentProgram%',inttostr(RM[deviceindex].currentprogram),[rfignorecase]);
str:=stringreplace(str,'%CurrentProgramName%',RM[deviceindex].currentprogramname,[rfignorecase]);

form1.label15.caption:=str;inc(i);

str:=stringreplace(LabelNames[i],'[C]','  '+fl(ethrm[deviceindex].temps[i])+' C',[rfignorecase]);
str:=stringreplace(str,'[%]','  '+fl(ethrm[deviceindex].adcs[i])+' %',[rfignorecase]);
str:=stringreplace(str,'[-%]','  '+fl(100-ethrm[deviceindex].adcs[i])+' %',[rfignorecase]);
str:=stringreplace(str,'[MCP9700]','  '+fl(ethrm[deviceindex].tempsMCP9700[i])+' C',[rfignorecase]);
str:=stringreplace(str,'[MCP9701]','  '+fl(ethrm[deviceindex].tempsMCP9701[i])+' C',[rfignorecase]);
str:=stringreplace(str,'[]','  '+fl(ethrm[deviceindex].adcsind[i])+' ',[rfignorecase]);
str:=stringreplace(str,'%CurrentProgram%',inttostr(RM[deviceindex].currentprogram),[rfignorecase]);
str:=stringreplace(str,'%CurrentProgramName%',RM[deviceindex].currentprogramname,[rfignorecase]);

form1.label16.caption:=str;inc(i);
//-----------------------------------------------------------------------
bonfire_status:=stringreplace(bonfire_status,'bonfire','',[rfignorecase]);
solar_status:=stringreplace(solar_status,'solar','',[rfignorecase]);
boiler_status:=stringreplace(boiler_status,'boiler','',[rfignorecase]);
str:=stringreplace(LabelNames[i],'%StatusBonfire%',bonfire_status,[rfignorecase]);
str:=stringreplace(str,'%StatusBoiler%',boiler_status,[rfignorecase]);
str:=stringreplace(str,'%StatusSolar%',solar_status,[rfignorecase]);
str:=stringreplace(str,'%StatusVentilation%',recuperator_status,[rfignorecase]);
str:=stringreplace(str,'%CurrentProgram%',inttostr(RM[deviceindex].currentprogram),[rfignorecase]);
str:=stringreplace(str,'%CurrentProgramName%',RM[deviceindex].currentprogramname,[rfignorecase]);
form1.label17.caption:=str;inc(i);

str:=stringreplace(LabelNames[i],'%StatusBonfire%',bonfire_status,[rfignorecase]);
str:=stringreplace(str,'%StatusBoiler%',boiler_status,[rfignorecase]);
str:=stringreplace(str,'%StatusSolar%',solar_status,[rfignorecase]);
str:=stringreplace(str,'%StatusVentilation%',recuperator_status,[rfignorecase]);
str:=stringreplace(str,'%CurrentProgram%',inttostr(RM[deviceindex].currentprogram),[rfignorecase]);
str:=stringreplace(str,'%CurrentProgramName%',RM[deviceindex].currentprogramname,[rfignorecase]);
form1.label18.caption:=str;inc(i);

str:=stringreplace(LabelNames[i],'%StatusBonfire%',bonfire_status,[rfignorecase]);
str:=stringreplace(str,'%StatusBoiler%',boiler_status,[rfignorecase]);
str:=stringreplace(str,'%StatusSolar%',solar_status,[rfignorecase]);
str:=stringreplace(str,'%StatusVentilation%',recuperator_status,[rfignorecase]);
str:=stringreplace(str,'%CurrentProgram%',inttostr(RM[deviceindex].currentprogram),[rfignorecase]);
str:=stringreplace(str,'%CurrentProgramName%',RM[deviceindex].currentprogramname,[rfignorecase]);
form1.label19.caption:=str;inc(i);

str:=stringreplace(LabelNames[i],'%StatusBonfire%',bonfire_status,[rfignorecase]);
str:=stringreplace(str,'%StatusBoiler%',boiler_status,[rfignorecase]);
str:=stringreplace(str,'%StatusSolar%',solar_status,[rfignorecase]);
str:=stringreplace(str,'%StatusVentilation%',recuperator_status,[rfignorecase]);
str:=stringreplace(str,'%CurrentProgram%',inttostr(RM[deviceindex].currentprogram),[rfignorecase]);
str:=stringreplace(str,'%CurrentProgramName%',RM[deviceindex].currentprogramname,[rfignorecase]);
form1.label20.caption:=str;inc(i);

str:=stringreplace(LabelNames[i],'%StatusBonfire%',bonfire_status,[rfignorecase]);
str:=stringreplace(str,'%StatusBoiler%',boiler_status,[rfignorecase]);
str:=stringreplace(str,'%StatusSolar%',solar_status,[rfignorecase]);
str:=stringreplace(str,'%StatusVentilation%',recuperator_status,[rfignorecase]);
str:=stringreplace(str,'%CurrentProgram%',inttostr(RM[deviceindex].currentprogram),[rfignorecase]);
str:=stringreplace(str,'%CurrentProgramName%',RM[deviceindex].currentprogramname,[rfignorecase]);
form1.label21.caption:=str;inc(i);

str:=stringreplace(LabelNames[i],'%StatusBonfire%',bonfire_status,[rfignorecase]);
str:=stringreplace(str,'%StatusBoiler%',boiler_status,[rfignorecase]);
str:=stringreplace(str,'%StatusSolar%',solar_status,[rfignorecase]);
str:=stringreplace(str,'%StatusVentilation%',recuperator_status,[rfignorecase]);
str:=stringreplace(str,'%CurrentProgram%',inttostr(RM[deviceindex].currentprogram),[rfignorecase]);
str:=stringreplace(str,'%CurrentProgramName%',RM[deviceindex].currentprogramname,[rfignorecase]);
form1.label22.caption:=str;inc(i);

str:=stringreplace(LabelNames[i],'%StatusBonfire%',bonfire_status,[rfignorecase]);
str:=stringreplace(str,'%StatusBoiler%',boiler_status,[rfignorecase]);
str:=stringreplace(str,'%StatusSolar%',solar_status,[rfignorecase]);
str:=stringreplace(str,'%StatusVentilation%',recuperator_status,[rfignorecase]);
str:=stringreplace(str,'%CurrentProgram%',inttostr(RM[deviceindex].currentprogram),[rfignorecase]);
str:=stringreplace(str,'%CurrentProgramName%',RM[deviceindex].currentprogramname,[rfignorecase]);
form1.label23.caption:=str;inc(i);

str:=stringreplace(LabelNames[i],'%StatusBonfire%',bonfire_status,[rfignorecase]);
str:=stringreplace(str,'%StatusBoiler%',boiler_status,[rfignorecase]);
str:=stringreplace(str,'%StatusSolar%',solar_status,[rfignorecase]);
str:=stringreplace(str,'%StatusVentilation%',recuperator_status,[rfignorecase]);
str:=stringreplace(str,'%CurrentProgram%',inttostr(RM[deviceindex].currentprogram),[rfignorecase]);
str:=stringreplace(str,'%CurrentProgramName%',RM[deviceindex].currentprogramname,[rfignorecase]);
form1.label24.caption:=str;inc(i);

str:=stringreplace(LabelNames[i],'%StatusBonfire%',bonfire_status,[rfignorecase]);
str:=stringreplace(str,'%StatusBoiler%',boiler_status,[rfignorecase]);
str:=stringreplace(str,'%StatusSolar%',solar_status,[rfignorecase]);
str:=stringreplace(str,'%StatusVentilation%',recuperator_status,[rfignorecase]);
str:=stringreplace(str,'%CurrentProgram%',inttostr(RM[deviceindex].currentprogram),[rfignorecase]);
str:=stringreplace(str,'%CurrentProgramName%',RM[deviceindex].currentprogramname,[rfignorecase]);
form1.label25.caption:=str;inc(i);


//          writeln(tf,'Bonfire: ');
//  writeln(tf,'Boiler: ');
//  writeln(tf,'Vent: ');
//  writeln(tf,'Solar: ')
//bonfire_status:string;  //status of bonfire for HeatManager
//boiler_status:string;   //status of boiler for HM
//Solar_status:string;    //status of solar system
//recuperator_status:string;// status of recuperation, ventilation, air heating



        caption:='eHouse Control Panel: '+ethrm[deviceindex].devname+' '+formatdatetime('yyyy-mm-dd, hh:nn:ss',ethrm[deviceindex].datetime)  //set caption of main form do RoomManager Name - pokazuje w naglówku formularza nazwê roommanagera
        ;      admem('');
//else
//    form1.caption:=trim(recuperator_status)+' '
//+trim(bonfire_status)+' '  //status of bonfire for HeatManager
//+trim(boiler_status)+' '   //status of boiler for HM
//+trim(Solar_status)+' '    //status of solar system
//+formatdatetime({'yyyy-mm-dd, }//'hh:nn:ss',rm[deviceindex].datetime)+' '+ rm[deviceindex].devname+' ';// status of recuperation, ventilation, air heating
  //set caption of main form do RoomManager Name - pokazuje w naglówku formularza nazwê roommanagera
//form1.refresh;
//}
end;

/////////////////////////////////////////////////////////////////////////////////
// UDP reception event handler
///////////////////////////////////////////////////////////////////////////////
procedure TForm1.NMUDP1DataReceived(Sender: TComponent;
  NumberBytes: Integer; FromIP: String; Port: Integer);
var   C: String;
  MyStream: TMemoryStream;

begin
if filesystem_status then exit;
MyStream := TMemoryStream.Create;
NMUDP1.ReadStream(MyStream);
SetLength(C, NumberBytes);
MyStream.Read(C[1], NumberBytes);
update_status_udp(C);
update_panel;
update_panel_tcp;
end;
////////////////////////////////////////////////////
//udp listener binary status reception from controllers or ehouse.exe application
//////////////////////////////////////////////////////
procedure TForm1.binaryDataReceived(Sender: TComponent;
  NumberBytes: Integer; FromIP: String; Port: Integer);
var   C: array[0..1024] of char;
  MyStream: TMemoryStream;
numberb:integer;
i:integer;
CheckSum:integer;
CalcCheckSum:integer;
begin

CalcCheckSum:=0;
if filesystem_status then exit;
MyStream := TMemoryStream.Create;
binary.ReadStream(MyStream);
numberb:=NumberBytes;
if numberb>1023 then numberb:=1023;   //limiting number of bytes received
if numberb<6 then exit;
MyStream.Read(C[0], numberb);
CheckSum:=integer(C[numberb-2]);
CheckSum:=CheckSum shl 8;
CheckSum:=CheckSum + integer(C[numberb-1]);
numberb:=numberb-2;
for i:=0 to numberb-1 do                       //Verify checksum recently added to udp status
        begin
        CalcCheckSum:=CalcCheckSum+integer(C[i]);
        end;
CalcCheckSum:=CalcCheckSum and $ffff;           //truncate to 16bit value
if (CalcCheckSum=checksum) then                 //compare with added to the end of status checksum value
        begin
        set_rm(C,1);                            //decode ehouse 1 controllers status
        set_status_commmanager(C);              //decode commanager controller status
        set_status_ethroommanager(C);           //decode other ethernet controllers status
        Test_save;                              //test save data to text files for each RM, HM
        Test_save_commmanager;                  //test save data to text file for CommManager
        Test_save_eth;                          //test save data to text file for  each Ethernet Controller
        update_panel;                           //update data to panel for selected controller
        update_panel_tcp;                       //update data to panel for selected controller
        end;
end;
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
// ADC Program Buttons event handler for ehternet controllers
// lunch event if button is pressed
//
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TForm1.ADCProgram1Click(Sender: TObject);
var
cl:tcolor;
str:string;
int:integer;
begin
str:=stringreplace((sender as tpanel).name,'adcprogram','',[rfignorecase]);
int:=chk_int(str)-1;
runevent($61,int,255,255,255,255,(sender as tpanel).caption);

cl:=(sender as tpanel).color;
(sender as tpanel).Bevelinner:=bvLowered;
(sender as tpanel).BevelOuter:=bvLowered;
(sender as tpanel).color:=clltgray;
(sender as tpanel).refresh;
form1.refresh;
sleep(200);
(sender as tpanel).color:=cl;
(sender as tpanel).Bevelinner:=bvRaised;
(sender as tpanel).BevelOuter:=bvRaised;
(sender as tpanel).refresh;
form1.refresh;

end;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
// TCP Client socket disconnect
//
/////////////////////////////////////////////////////////////////////////////////
procedure TForm1.berkeleyDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin

//  admem('Disconnect from Controller');

SocketStatus:=NOTAUTHORIZED;
end;
//////////////////////////////////////////////////////////////////////////////////
//
//Ethernet TCP event send init to ethernet ehouse controllers
//
/////////////////////////////////////////////////////////////////////////////////
procedure sendsoc(TCP_MODE:integer);
begin
tcpmode:=TCP_MODE;
TimeOutClientSocket:=TIMEOUT_TCP_SOCKET;
SocketStatus:=NOTAUTHORIZED;
BerkeleyNotComplete:=true;
berkeleystatusok:=false;

form1.berkeley.active:=true;
form1.timer1.Enabled:=true;

end;
////////////////////////////////////////////////////////////////////////////////
// add text to form caption for info
// and status
////////////////////////////////////////////////////////////////////////////////
procedure admem(str:string);
begin
if length(str)>0 then
if length(statusstr)>0 then
        statusstr:=statusstr+' ; '+str
else statusstr:=str;
form1.caption:=(caption+'    '+statusstr);

end;

//calculate response for authorisation xored password, password, none

procedure CalculateChalangeResponse(var resp:array of char);
var
response:array[0..200] of INTEGER;
i:integer;

authorisationmethod:integer;
str:string;

begin
fillchar(response,sizeof(response),0);
response[0] :=ord(resp[0]);
response[1] :=ord(resp[1]);
response[2] :=ord(resp[2]);
response[3] :=ord(resp[3]);
response[4] :=ord(resp[4]);
response[5] :=ord(resp[5]);

authorisationmethod:=0; ///unconditional chalange response
if (authorisationmethod<=1) then                  //xored pass
        begin
        while length(password)<6 do password:=password+'a';
{        form1.memo1.lines.add(password[1]);
        form1.memo1.lines.add(password[2]);
        form1.memo1.lines.add(password[3]);
        form1.memo1.lines.add(password[4]);
        form1.memo1.lines.add(password[5]);
        form1.memo1.lines.add(password[6]);}
        response[6] :=(response[0] xor ord(password[1])) xor (Vendor_code[0]);
        response[7] :=(response[1] xor ord(password[2])) xor (Vendor_code[1]);
        response[8] :=(response[2] xor ord(password[3])) xor (Vendor_code[2]);
        response[9] :=(response[3] xor ord(password[4])) xor (Vendor_code[3]);
        response[10]:=(response[4] xor ord(password[5])) xor (Vendor_code[4]);
        response[11]:=(response[5] xor ord(password[6])) xor (Vendor_code[5]);
        end
else
if (authorisationmethod=2) then                 //just pass
        begin
        while length(password)<6 do password:=password+'a';
        response[6] :=ord(password[1]) xor (Vendor_code[1]);
        response[7] :=ord(password[2]) xor (Vendor_code[2]);
        response[8] :=ord(password[3]) xor (Vendor_code[3]);
        response[9] :=ord(password[4]) xor (Vendor_code[4]);
        response[10]:=ord(password[5]) xor (Vendor_code[5]);
        response[11]:=ord(password[6]) xor (Vendor_code[6]);
        end
else
        if (authorisationmethod=3) then                 //replayed response
         begin
        //while length(password)<6 do password:=password+'a';
        response[6] :=response[0];
        response[7] :=response[1];
        response[8] :=response[2];
        response[9] :=response[3];
        response[10]:=response[4];
        response[11]:=response[5];
        end;
response[12]:=(13);
response[13]:=0;
for i:=0 to 13 do
        resp[i]:=chr(response[i] and $ff);
//result:=response;
end;





////////////////////////////////////////////////////////////////////////////////
//
// TCP Client connection to controllers for direct event submition
// received data event handler
//
////////////////////////////////////////////////////////////////////////////////
procedure TForm1.berkeleyRead(Sender: TObject; Socket: TCustomWinSocket);
var buff:array[0..300]of char;
iter:integer;
siz:array[0..500]of char;
tmstr,stt:string;
BytesRead:integer;
tf:textfile;
tm_hour,tm_min,tm_sec,seccount,tm_year,tm_mon,tm_mday:word;
tm_seccount,tm_wday,m,i,k:integer;
tosend,str:string;
flo:double;
ssss:string;
begin
if (SocketStatus=NOTAUTHORIZED) then                                           //get chalange code
        begin

        fillchar(buff,sizeof(buff),0);
        BytesRead:=Socket.ReceiveBuf(buff,6);
        if (BytesRead=6) then
                begin
                BytesRead:=0;
                str:='';
                for i:=0 to 5 do
                        begin
                        tmstr:=format('%x',[ord(buff[i])]);
                        if length(tmstr)<2 then tmstr:='0'+tmstr;
                        str:=str+tmstr+' ';
                        end;
                memo1.Lines.Add(str);
                CalculateChalangeResponse(buff);                              //send response to the challange together with event to run
                i:=0;
  {              buff[i]:=chr(response[i]);inc(i);//0
                buff[i]:=chr(response[i]);inc(i);//1
                buff[i]:=chr(response[i]);inc(i);//2
                buff[i]:=chr(response[i]);inc(i);//3
                buff[i]:=chr(response[i]);inc(i);//4
                buff[i]:=chr(response[i]);inc(i);//5
                buff[i]:=chr(response[i]);inc(i);//6
                buff[i]:=chr(response[i]);inc(i);//7
                buff[i]:=chr(response[i]);inc(i);//8
                buff[i]:=chr(response[i]);inc(i);//9
                buff[i]:=chr(response[i]);inc(i);//10
                buff[i]:=chr(response[i]);inc(i);//11
                buff[i]:=chr(response[i]);inc(i);//12}

                i:=13;
                buff[i]:=#10;inc(i);         //13
                buff[i]:=chr(evnt[0]);inc(i);//14
                buff[i]:=chr(evnt[1]);inc(i);//15
                buff[i]:=chr(evnt[2]);inc(i);//16
                buff[i]:=chr(evnt[3]);inc(i);//17
                buff[i]:=chr(evnt[4]);inc(i);//18
                buff[i]:=chr(evnt[5]);inc(i);//19
                buff[i]:=chr(evnt[6]);inc(i);//20
                buff[i]:=chr(evnt[7]);inc(i);//21
                buff[i]:=chr(evnt[8]);inc(i);//22
                buff[i]:=chr(evnt[9]);inc(i);//23
                buff[i]:=chr(0);  //24
                str:='';
                for i:=0 to 24 do
                        begin
                        tmstr:=format('%x',[ord(buff[i])]);
                        if length(tmstr)<2 then tmstr:='0'+tmstr;
                        str:=str+tmstr+' ';
                        end;
                memo1.Lines.Add(str);
                K:=-1;
                iter:=10;
                while k<24 do
                 begin
                        k:=Socket.SendBuf(buff,24);
                        dec(iter);
                        if iter=0 then begin killsocket;exit;end;
                        end;
                k:=-1;
                SocketStatus:=GET_CONFIRMATION;                 //go to confirmation state
                            //will lunch this function when new data come
                exit;
                end;
        end  ;
//else
        if (SocketStatus=GET_CONFIRMATION) then                 //confirmation of event state
                begin
                k:=Socket.ReceiveBuf(buff,1);
                if (k>0) then
                        if (buff[0]='+') then                           //received confirmation '+' of event acceptance
                                begin
                                admem('Event Send Ok');
                                buff[0]:=#0;                            //send 0 for termination socket on controller side
                                k:=Socket.SendBuf(buff,1);
//                                Socket.Write
//                                Socket.Write(socket.SocketHandle);
                                killsocket;
                                berkeleystatusok:=true;
                                end
                        else                                            //event not confirmed: no space, communication error, etc
                                begin
                                admem('Event Not Confirmed');
                                berkeleystatusok:=false;
                                killsocket;
                                end;
                end;


end;
/////////////////////////////////////////////////////////////////////////////////
//
// Close sockets of TCP client for sending event
//
////////////////////////////////////////////////////////////////////////////////
procedure KillSocket;
begin
//admem('kill socket');
SocketStatus:=NOTAUTHORIZED;
if form1.berkeley.Socket.Connected then
        form1.berkeley.Socket.Close;
form1.berkeley.Close;
if form1.berkeley.Active then
        form1.berkeley.Active:=false;
BerkeleyNotComplete:=false;
berkeleystatusok:=false;
end;









/////////////////////////////////////////////////////////////////////////////
//
// Error Event Handler of TCP socket for sending event
// just add event code to status
//
/////////////////////////////////////////////////////////////////////////////
procedure TForm1.berkeleyError(Sender: TObject; Socket: TCustomWinSocket;
  ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
admem('Socket Error: '+inttostr(Errorcode));
ErrorCode:=0;
killsocket;

end;
/////////////////////////////////////////////////////////////////////////////////
//
// After connection event handler of tcp socket for sending event
//
////////////////////////////////////////////////////////////////////////////////
procedure TForm1.berkeleyConnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  admem('Connected');
end;

procedure TForm1.berkeleyConnecting(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  admem(berkeley.host+':'+inttostr(berkeley.port));
end;

procedure TForm1.berkeleyLookup(Sender: TObject; Socket: TCustomWinSocket);
begin
// admem('Loockup');
end;

procedure TForm1.berkeleyWrite(Sender: TObject; Socket: TCustomWinSocket);
begin
//  admem('berkeley write');
end;

procedure TForm1.binaryInvalidHost(var handled: Boolean);
begin
form1.caption:='Invalid Host';
end;

procedure TForm1.binaryStatus(Sender: TComponent; status: String);
begin
form1.Caption:='UDP: '+status;
end;

procedure TForm1.binaryStreamInvalid(var handled: Boolean;
  Stream: TStream);
begin
Form1.Caption:='UDP : Invalid Stream';
end;

procedure TForm1.binaryBufferInvalid(var handled: Boolean;
  var Buff: array of Char; var length: Integer);
begin
form1.caption:='UDP : Invalid Buffer';
end;

procedure TForm1.DeviceListChange(Sender: TObject);
var indx:integer;
begin
if (Sender is ttabcontrol) then
        indx:=((Sender as ttabcontrol).Tabindex)
else indx:=0;

TabName:=DeviceList.Tabs.Strings[indx];
//if (not firstitme)
formcreate(nil);
end;

procedure TForm1.FormActivate(Sender: TObject);
begin
if (FirstTime)          then
        begin
        firsttime:=false;
        DeviceList.TabIndex:=0;
        DeviceListChange(nil);
 //       formcreate(nil);
        end;


end;

end.
