<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE eagle SYSTEM "eagle.dtd">
<eagle version="9.7.0">
  <drawing>
    <settings>
      <setting alwaysvectorfont="no"/>
      <setting verticaltext="up"/>
    </settings>
    <grid distance="0.1" unitdist="inch" unit="inch" style="lines" multiple="1" display="no" altdistance="0.01" altunitdist="inch" altunit="inch"/>
    <layers>
      <layer number="91" name="Nets" color="2" fill="1" visible="yes" active="yes"/>
      <layer number="92" name="Busses" color="1" fill="1" visible="yes" active="yes"/>
      <layer number="93" name="Pins" color="2" fill="1" visible="yes" active="yes"/>
      <layer number="94" name="Symbols" color="4" fill="1" visible="yes" active="yes"/>
      <layer number="95" name="Names" color="7" fill="1" visible="yes" active="yes"/>
      <layer number="96" name="Values" color="7" fill="1" visible="yes" active="yes"/>
      <layer number="97" name="Info" color="7" fill="1" visible="yes" active="yes"/>
      <layer number="98" name="Guide" color="6" fill="1" visible="yes" active="yes"/>
    </layers>
    <schematic xreflabel="%F%N/%S.%C%R" xrefpart="/%S.%C%R">
      <libraries>
        <library name="rejsacan_synth">
          <description>Synthesized from EasyEDA source.</description>
          <packages/>
          <symbols>
            <symbol name="SYM_SPI">
              <text x="-1.27" y="4.31" size="1.778" layer="95">&gt;NAME</text>
              <text x="-1.27" y="-6.31" size="1.778" layer="96">&gt;VALUE</text>
              <pin name="3" x="-3.81" y="-2.54" length="point" rot="R0" direction="pas" visible="pad"/>
              <pin name="1" x="-3.81" y="2.54" length="point" rot="R0" direction="pas" visible="pad"/>
              <pin name="2" x="-3.81" y="-0" length="point" rot="R0" direction="pas" visible="pad"/>
            </symbol>
            <symbol name="SYM_R15">
              <text x="-6.35" y="4.31" size="1.778" layer="95">&gt;NAME</text>
              <text x="-6.35" y="0.04" size="1.778" layer="96">&gt;VALUE</text>
              <pin name="2" x="5.08" y="-0" length="point" rot="R90" direction="pas" visible="pad"/>
              <pin name="1" x="-5.08" y="-0" length="point" rot="R90" direction="pas" visible="pad"/>
            </symbol>
            <symbol name="SYM_POWER">
              <text x="-1.27" y="3.04" size="1.778" layer="95">&gt;NAME</text>
              <text x="-1.27" y="-5.04" size="1.778" layer="96">&gt;VALUE</text>
              <pin name="1" x="-3.81" y="1.27" length="point" rot="R0" direction="pas" visible="pad"/>
              <pin name="2" x="-3.81" y="-1.27" length="point" rot="R0" direction="pas" visible="pad"/>
            </symbol>
            <symbol name="SYM_GPIO">
              <text x="-2.54" y="5.58" size="1.778" layer="95">&gt;NAME</text>
              <text x="-2.54" y="-7.58" size="1.778" layer="96">&gt;VALUE</text>
              <pin name="1" x="-5.08" y="3.81" length="point" rot="R0" direction="pas" visible="pad"/>
              <pin name="2" x="-5.08" y="1.27" length="point" rot="R0" direction="pas" visible="pad"/>
              <pin name="3" x="-5.08" y="-1.27" length="point" rot="R0" direction="pas" visible="pad"/>
              <pin name="4" x="-5.08" y="-3.81" length="point" rot="R0" direction="pas" visible="pad"/>
            </symbol>
            <symbol name="SYM_I2C">
              <text x="-2.54" y="5.58" size="1.778" layer="95">&gt;NAME</text>
              <text x="-2.54" y="-7.58" size="1.778" layer="96">&gt;VALUE</text>
              <pin name="1" x="-5.08" y="3.81" length="point" rot="R0" direction="pas" visible="pad"/>
              <pin name="2" x="-5.08" y="1.27" length="point" rot="R0" direction="pas" visible="pad"/>
              <pin name="3" x="-5.08" y="-1.27" length="point" rot="R0" direction="pas" visible="pad"/>
              <pin name="4" x="-5.08" y="-3.81" length="point" rot="R0" direction="pas" visible="pad"/>
            </symbol>
            <symbol name="SYM_CAN">
              <text x="-1.27" y="3.04" size="1.778" layer="95">&gt;NAME</text>
              <text x="-1.27" y="-5.04" size="1.778" layer="96">&gt;VALUE</text>
              <pin name="1" x="-3.81" y="1.27" length="point" rot="R0" direction="pas" visible="pad"/>
              <pin name="2" x="-3.81" y="-1.27" length="point" rot="R0" direction="pas" visible="pad"/>
            </symbol>
            <symbol name="SYM_YELLOW">
              <text x="-6.35" y="3.04" size="1.778" layer="95">&gt;NAME</text>
              <text x="-6.35" y="-1.23" size="1.778" layer="96">&gt;VALUE</text>
              <pin name="1" x="-5.08" y="-1.27" length="point" rot="R90" direction="pas" visible="pad"/>
              <pin name="2" x="5.08" y="-1.27" length="point" rot="R90" direction="pas" visible="pad"/>
            </symbol>
            <symbol name="SYM_BLUE">
              <text x="-6.35" y="6.342" size="1.778" layer="95">&gt;NAME</text>
              <text x="-6.35" y="2.072" size="1.778" layer="96">&gt;VALUE</text>
              <pin name="1" x="5.08" y="2.032" length="point" rot="R90" direction="pas" visible="pad"/>
              <pin name="2" x="-5.08" y="2.032" length="point" rot="R90" direction="pas" visible="pad"/>
            </symbol>
            <symbol name="SYM_GREEN">
              <text x="-6.35" y="3.04" size="1.778" layer="95">&gt;NAME</text>
              <text x="-6.35" y="-1.23" size="1.778" layer="96">&gt;VALUE</text>
              <pin name="1" x="-5.08" y="-1.27" length="point" rot="R90" direction="pas" visible="pad"/>
              <pin name="2" x="5.08" y="-1.27" length="point" rot="R90" direction="pas" visible="pad"/>
            </symbol>
            <symbol name="SYM_R13">
              <text x="-6.35" y="4.31" size="1.778" layer="95">&gt;NAME</text>
              <text x="-6.35" y="0.04" size="1.778" layer="96">&gt;VALUE</text>
              <pin name="2" x="5.08" y="0" length="point" rot="R90" direction="pas" visible="pad"/>
              <pin name="1" x="-5.08" y="0" length="point" rot="R90" direction="pas" visible="pad"/>
            </symbol>
            <symbol name="SYM_R14">
              <text x="-6.35" y="4.31" size="1.778" layer="95">&gt;NAME</text>
              <text x="-6.35" y="0.04" size="1.778" layer="96">&gt;VALUE</text>
              <pin name="2" x="5.08" y="-0" length="point" rot="R90" direction="pas" visible="pad"/>
              <pin name="1" x="-5.08" y="-0" length="point" rot="R90" direction="pas" visible="pad"/>
            </symbol>
            <symbol name="SYM_PROG">
              <text x="-8.89" y="4.31" size="1.778" layer="95">&gt;NAME</text>
              <text x="-8.89" y="0.04" size="1.778" layer="96">&gt;VALUE</text>
              <pin name="1" x="7.62" y="-0" length="point" rot="R90" direction="pas" visible="pad"/>
              <pin name="2" x="-7.62" y="-0" length="point" rot="R90" direction="pas" visible="pad"/>
            </symbol>
            <symbol name="SYM_R7">
              <text x="-6.35" y="4.31" size="1.778" layer="95">&gt;NAME</text>
              <text x="-6.35" y="0.04" size="1.778" layer="96">&gt;VALUE</text>
              <pin name="2" x="-5.08" y="0" length="point" rot="R90" direction="pas" visible="pad"/>
              <pin name="1" x="5.08" y="0" length="point" rot="R90" direction="pas" visible="pad"/>
            </symbol>
            <symbol name="SYM_R5">
              <text x="-6.35" y="4.31" size="1.778" layer="95">&gt;NAME</text>
              <text x="-6.35" y="0.04" size="1.778" layer="96">&gt;VALUE</text>
              <pin name="2" x="-5.08" y="0" length="point" rot="R90" direction="pas" visible="pad"/>
              <pin name="1" x="5.08" y="0" length="point" rot="R90" direction="pas" visible="pad"/>
            </symbol>
            <symbol name="SYM_Q1">
              <wire x1="-3.81" y1="-1.27" x2="-1.27" y2="-1.27" width="0.254" layer="94"/>
              <wire x1="-1.27" y1="-1.27" x2="-1.27" y2="1.27" width="0.254" layer="94"/>
              <wire x1="-1.27" y1="1.27" x2="-3.81" y2="1.27" width="0.254" layer="94"/>
              <wire x1="-3.81" y1="1.27" x2="-3.81" y2="-1.27" width="0.254" layer="94"/>
              <text x="-3.81" y="1.77" size="1.778" layer="95">&gt;NAME</text>
              <text x="-3.81" y="-3.77" size="1.778" layer="96">&gt;VALUE</text>
              <pin name="3" x="0" y="5.08" length="point" rot="R270" direction="pas" visible="pad"/>
              <pin name="1" x="-5.08" y="-0" length="point" rot="R0" direction="pas" visible="pad"/>
              <pin name="2" x="0" y="-5.08" length="point" rot="R90" direction="pas" visible="pad"/>
            </symbol>
            <symbol name="SYM_U3">
              <text x="0" y="4.31" size="1.778" layer="95">&gt;NAME</text>
              <text x="0" y="-6.31" size="1.778" layer="96">&gt;VALUE</text>
              <pin name="1" x="-2.54" y="2.54" length="point" rot="R0" direction="pas" visible="pad"/>
              <pin name="2" x="-2.54" y="0" length="point" rot="R0" direction="pas" visible="pad"/>
              <pin name="3" x="-2.54" y="-2.54" length="point" rot="R0" direction="pas" visible="pad"/>
            </symbol>
            <symbol name="SYM_L1">
              <text x="-6.35" y="4.31" size="1.778" layer="95">&gt;NAME</text>
              <text x="-6.35" y="0.04" size="1.778" layer="96">&gt;VALUE</text>
              <pin name="2" x="5.08" y="-0" length="point" rot="R90" direction="pas" visible="pad"/>
              <pin name="1" x="-5.08" y="-0" length="point" rot="R90" direction="pas" visible="pad"/>
            </symbol>
            <symbol name="SYM_R16">
              <text x="-6.35" y="4.31" size="1.778" layer="95">&gt;NAME</text>
              <text x="-6.35" y="0.04" size="1.778" layer="96">&gt;VALUE</text>
              <pin name="2" x="-5.08" y="0" length="point" rot="R90" direction="pas" visible="pad"/>
              <pin name="1" x="5.08" y="0" length="point" rot="R90" direction="pas" visible="pad"/>
            </symbol>
            <symbol name="SYM_C12">
              <text x="-6.35" y="4.31" size="1.778" layer="95">&gt;NAME</text>
              <text x="-6.35" y="0.04" size="1.778" layer="96">&gt;VALUE</text>
              <pin name="1" x="5.08" y="0" length="point" rot="R90" direction="pas" visible="pad"/>
              <pin name="2" x="-5.08" y="0" length="point" rot="R90" direction="pas" visible="pad"/>
            </symbol>
            <symbol name="SYM_C11">
              <text x="-6.35" y="4.31" size="1.778" layer="95">&gt;NAME</text>
              <text x="-6.35" y="0.04" size="1.778" layer="96">&gt;VALUE</text>
              <pin name="1" x="5.08" y="0" length="point" rot="R90" direction="pas" visible="pad"/>
              <pin name="2" x="-5.08" y="0" length="point" rot="R90" direction="pas" visible="pad"/>
            </symbol>
            <symbol name="SYM_U5">
              <wire x1="-1.27" y1="-1.27" x2="1.27" y2="-1.27" width="0.254" layer="94"/>
              <wire x1="1.27" y1="-1.27" x2="1.27" y2="1.27" width="0.254" layer="94"/>
              <wire x1="1.27" y1="1.27" x2="-1.27" y2="1.27" width="0.254" layer="94"/>
              <wire x1="-1.27" y1="1.27" x2="-1.27" y2="-1.27" width="0.254" layer="94"/>
              <text x="-1.27" y="1.77" size="1.778" layer="95">&gt;NAME</text>
              <text x="-1.27" y="-3.77" size="1.778" layer="96">&gt;VALUE</text>
              <pin name="1" x="12.7" y="2.54" length="point" rot="R180" direction="pas" visible="pad"/>
              <pin name="2" x="12.7" y="-0" length="point" rot="R180" direction="pas" visible="pad"/>
              <pin name="3" x="12.7" y="-2.54" length="point" rot="R180" direction="pas" visible="pad"/>
              <pin name="4" x="-12.7" y="-2.54" length="point" rot="R0" direction="pas" visible="pad"/>
              <pin name="5" x="-12.7" y="2.54" length="point" rot="R0" direction="pas" visible="pad"/>
            </symbol>
            <symbol name="SYM_R10">
              <text x="-6.35" y="4.31" size="1.778" layer="95">&gt;NAME</text>
              <text x="-6.35" y="0.04" size="1.778" layer="96">&gt;VALUE</text>
              <pin name="2" x="-5.08" y="-0" length="point" rot="R90" direction="pas" visible="pad"/>
              <pin name="1" x="5.08" y="-0" length="point" rot="R90" direction="pas" visible="pad"/>
            </symbol>
            <symbol name="SYM_D5">
              <text x="-6.35" y="4.31" size="1.778" layer="95">&gt;NAME</text>
              <text x="-6.35" y="0.04" size="1.778" layer="96">&gt;VALUE</text>
              <pin name="2" x="-5.08" y="-0" length="point" rot="R90" direction="pas" visible="pad"/>
              <pin name="1" x="5.08" y="-0" length="point" rot="R90" direction="pas" visible="pad"/>
            </symbol>
            <symbol name="SYM_D2">
              <text x="-6.35" y="4.31" size="1.778" layer="95">&gt;NAME</text>
              <text x="-6.35" y="0.04" size="1.778" layer="96">&gt;VALUE</text>
              <pin name="2" x="5.08" y="-0" length="point" rot="R90" direction="pas" visible="pad"/>
              <pin name="1" x="-5.08" y="-0" length="point" rot="R90" direction="pas" visible="pad"/>
            </symbol>
            <symbol name="SYM_D3">
              <text x="-6.35" y="4.31" size="1.778" layer="95">&gt;NAME</text>
              <text x="-6.35" y="0.04" size="1.778" layer="96">&gt;VALUE</text>
              <pin name="2" x="5.08" y="-0" length="point" rot="R90" direction="pas" visible="pad"/>
              <pin name="1" x="-5.08" y="-0" length="point" rot="R90" direction="pas" visible="pad"/>
            </symbol>
            <symbol name="SYM_D1">
              <text x="-6.35" y="4.31" size="1.778" layer="95">&gt;NAME</text>
              <text x="-6.35" y="0.04" size="1.778" layer="96">&gt;VALUE</text>
              <pin name="2" x="-5.08" y="0" length="point" rot="R90" direction="pas" visible="pad"/>
              <pin name="1" x="5.08" y="0" length="point" rot="R90" direction="pas" visible="pad"/>
            </symbol>
            <symbol name="SYM_RESET">
              <text x="-8.89" y="4.31" size="1.778" layer="95">&gt;NAME</text>
              <text x="-8.89" y="0.04" size="1.778" layer="96">&gt;VALUE</text>
              <pin name="1" x="7.62" y="-0" length="point" rot="R90" direction="pas" visible="pad"/>
              <pin name="2" x="-7.62" y="-0" length="point" rot="R90" direction="pas" visible="pad"/>
            </symbol>
            <symbol name="SYM_R3">
              <text x="-6.35" y="4.31" size="1.778" layer="95">&gt;NAME</text>
              <text x="-6.35" y="0.04" size="1.778" layer="96">&gt;VALUE</text>
              <pin name="2" x="5.08" y="-0" length="point" rot="R90" direction="pas" visible="pad"/>
              <pin name="1" x="-5.08" y="-0" length="point" rot="R90" direction="pas" visible="pad"/>
            </symbol>
            <symbol name="SYM_C1">
              <text x="-5.08" y="4.31" size="1.778" layer="95">&gt;NAME</text>
              <text x="-5.08" y="0.04" size="1.778" layer="96">&gt;VALUE</text>
              <pin name="1" x="3.81" y="-0" length="point" rot="R90" direction="pas" visible="pad"/>
              <pin name="2" x="-3.81" y="-0" length="point" rot="R90" direction="pas" visible="pad"/>
            </symbol>
            <symbol name="SYM_C4">
              <text x="-5.08" y="4.31" size="1.778" layer="95">&gt;NAME</text>
              <text x="-5.08" y="0.04" size="1.778" layer="96">&gt;VALUE</text>
              <pin name="1" x="3.81" y="0" length="point" rot="R90" direction="pas" visible="pad"/>
              <pin name="2" x="-3.81" y="0" length="point" rot="R90" direction="pas" visible="pad"/>
            </symbol>
            <symbol name="SYM_C2">
              <text x="-5.08" y="4.31" size="1.778" layer="95">&gt;NAME</text>
              <text x="-5.08" y="0.04" size="1.778" layer="96">&gt;VALUE</text>
              <pin name="1" x="3.81" y="0" length="point" rot="R90" direction="pas" visible="pad"/>
              <pin name="2" x="-3.81" y="0" length="point" rot="R90" direction="pas" visible="pad"/>
            </symbol>
            <symbol name="SYM_R1">
              <text x="-6.35" y="4.31" size="1.778" layer="95">&gt;NAME</text>
              <text x="-6.35" y="0.04" size="1.778" layer="96">&gt;VALUE</text>
              <pin name="2" x="-5.08" y="0" length="point" rot="R90" direction="pas" visible="pad"/>
              <pin name="1" x="5.08" y="0" length="point" rot="R90" direction="pas" visible="pad"/>
            </symbol>
            <symbol name="SYM_C3">
              <text x="-6.35" y="4.31" size="1.778" layer="95">&gt;NAME</text>
              <text x="-6.35" y="0.04" size="1.778" layer="96">&gt;VALUE</text>
              <pin name="1" x="5.08" y="0" length="point" rot="R90" direction="pas" visible="pad"/>
              <pin name="2" x="-5.08" y="0" length="point" rot="R90" direction="pas" visible="pad"/>
            </symbol>
            <symbol name="SYM_U2">
              <wire x1="-7.62" y1="-1.27" x2="7.62" y2="-1.27" width="0.254" layer="94"/>
              <wire x1="7.62" y1="-1.27" x2="7.62" y2="1.27" width="0.254" layer="94"/>
              <wire x1="7.62" y1="1.27" x2="-7.62" y2="1.27" width="0.254" layer="94"/>
              <wire x1="-7.62" y1="1.27" x2="-7.62" y2="-1.27" width="0.254" layer="94"/>
              <text x="-7.62" y="1.77" size="1.778" layer="95">&gt;NAME</text>
              <text x="-7.62" y="-3.77" size="1.778" layer="96">&gt;VALUE</text>
              <pin name="1" x="-10.16" y="3.81" length="point" rot="R0" direction="pas" visible="pad"/>
              <pin name="2" x="-10.16" y="1.27" length="point" rot="R0" direction="pas" visible="pad"/>
              <pin name="3" x="-10.16" y="-1.27" length="point" rot="R0" direction="pas" visible="pad"/>
              <pin name="4" x="-10.16" y="-3.81" length="point" rot="R0" direction="pas" visible="pad"/>
              <pin name="5" x="10.16" y="-3.81" length="point" rot="R180" direction="pas" visible="pad"/>
              <pin name="6" x="10.16" y="-1.27" length="point" rot="R180" direction="pas" visible="pad"/>
              <pin name="7" x="10.16" y="1.27" length="point" rot="R180" direction="pas" visible="pad"/>
              <pin name="8" x="10.16" y="3.81" length="point" rot="R180" direction="pas" visible="pad"/>
            </symbol>
            <symbol name="SYM_TERMINATION">
              <text x="-1.27" y="3.04" size="1.778" layer="95">&gt;NAME</text>
              <text x="-1.27" y="-5.04" size="1.778" layer="96">&gt;VALUE</text>
              <pin name="1" x="-3.81" y="1.27" length="point" rot="R0" direction="pas" visible="pad"/>
              <pin name="2" x="-3.81" y="-1.27" length="point" rot="R0" direction="pas" visible="pad"/>
            </symbol>
            <symbol name="SYM_R2">
              <text x="-6.35" y="4.31" size="1.778" layer="95">&gt;NAME</text>
              <text x="-6.35" y="0.04" size="1.778" layer="96">&gt;VALUE</text>
              <pin name="2" x="5.08" y="-0" length="point" rot="R90" direction="pas" visible="pad"/>
              <pin name="1" x="-5.08" y="-0" length="point" rot="R90" direction="pas" visible="pad"/>
            </symbol>
            <symbol name="SYM_F1">
              <text x="-6.35" y="4.31" size="1.778" layer="95">&gt;NAME</text>
              <text x="-6.35" y="0.04" size="1.778" layer="96">&gt;VALUE</text>
              <pin name="2" x="5.08" y="-0" length="point" rot="R90" direction="pas" visible="pad"/>
              <pin name="1" x="-5.08" y="-0" length="point" rot="R90" direction="pas" visible="pad"/>
            </symbol>
            <symbol name="SYM_R17">
              <text x="-6.35" y="4.31" size="1.778" layer="95">&gt;NAME</text>
              <text x="-6.35" y="0.04" size="1.778" layer="96">&gt;VALUE</text>
              <pin name="2" x="5.08" y="-0" length="point" rot="R90" direction="pas" visible="pad"/>
              <pin name="1" x="-5.08" y="-0" length="point" rot="R90" direction="pas" visible="pad"/>
            </symbol>
            <symbol name="SYM_C10">
              <text x="-6.35" y="4.31" size="1.778" layer="95">&gt;NAME</text>
              <text x="-6.35" y="0.04" size="1.778" layer="96">&gt;VALUE</text>
              <pin name="1" x="5.08" y="0" length="point" rot="R90" direction="pas" visible="pad"/>
              <pin name="2" x="-5.08" y="0" length="point" rot="R90" direction="pas" visible="pad"/>
            </symbol>
            <symbol name="SYM_C8">
              <text x="-6.35" y="4.31" size="1.778" layer="95">&gt;NAME</text>
              <text x="-6.35" y="0.04" size="1.778" layer="96">&gt;VALUE</text>
              <pin name="1" x="5.08" y="0" length="point" rot="R90" direction="pas" visible="pad"/>
              <pin name="2" x="-5.08" y="0" length="point" rot="R90" direction="pas" visible="pad"/>
            </symbol>
            <symbol name="SYM_C9">
              <text x="-6.35" y="4.31" size="1.778" layer="95">&gt;NAME</text>
              <text x="-6.35" y="0.04" size="1.778" layer="96">&gt;VALUE</text>
              <pin name="1" x="5.08" y="0" length="point" rot="R90" direction="pas" visible="pad"/>
              <pin name="2" x="-5.08" y="0" length="point" rot="R90" direction="pas" visible="pad"/>
            </symbol>
            <symbol name="SYM_D6">
              <text x="-6.35" y="4.31" size="1.778" layer="95">&gt;NAME</text>
              <text x="-6.35" y="0.04" size="1.778" layer="96">&gt;VALUE</text>
              <pin name="2" x="5.08" y="-0" length="point" rot="R90" direction="pas" visible="pad"/>
              <pin name="1" x="-5.08" y="-0" length="point" rot="R90" direction="pas" visible="pad"/>
            </symbol>
            <symbol name="SYM_D7">
              <text x="-6.35" y="4.31" size="1.778" layer="95">&gt;NAME</text>
              <text x="-6.35" y="0.04" size="1.778" layer="96">&gt;VALUE</text>
              <pin name="2" x="5.08" y="-0" length="point" rot="R90" direction="pas" visible="pad"/>
              <pin name="1" x="-5.08" y="-0" length="point" rot="R90" direction="pas" visible="pad"/>
            </symbol>
            <symbol name="SYM_SD-CARD">
              <text x="-8.89" y="17.01" size="1.778" layer="95">&gt;NAME</text>
              <text x="-8.89" y="-19.01" size="1.778" layer="96">&gt;VALUE</text>
              <pin name="1" x="-11.43" y="15.24" length="point" rot="R0" direction="pas" visible="pad"/>
              <pin name="2" x="-11.43" y="12.7" length="point" rot="R0" direction="pas" visible="pad"/>
              <pin name="3" x="-11.43" y="10.16" length="point" rot="R0" direction="pas" visible="pad"/>
              <pin name="4" x="-11.43" y="7.62" length="point" rot="R0" direction="pas" visible="pad"/>
              <pin name="5" x="-11.43" y="5.08" length="point" rot="R0" direction="pas" visible="pad"/>
              <pin name="6" x="-11.43" y="2.54" length="point" rot="R0" direction="pas" visible="pad"/>
              <pin name="7" x="-11.43" y="-0" length="point" rot="R0" direction="pas" visible="pad"/>
              <pin name="8" x="-11.43" y="-2.54" length="point" rot="R0" direction="pas" visible="pad"/>
              <pin name="9" x="-11.43" y="-5.08" length="point" rot="R0" direction="pas" visible="pad"/>
              <pin name="10" x="-11.43" y="-7.62" length="point" rot="R0" direction="pas" visible="pad"/>
              <pin name="11" x="-11.43" y="-10.16" length="point" rot="R0" direction="pas" visible="pad"/>
              <pin name="12" x="-11.43" y="-12.7" length="point" rot="R0" direction="pas" visible="pad"/>
              <pin name="13" x="-11.43" y="-15.24" length="point" rot="R0" direction="pas" visible="pad"/>
            </symbol>
            <symbol name="SYM_R4">
              <text x="-6.35" y="4.31" size="1.778" layer="95">&gt;NAME</text>
              <text x="-6.35" y="0.04" size="1.778" layer="96">&gt;VALUE</text>
              <pin name="2" x="-5.08" y="0" length="point" rot="R90" direction="pas" visible="pad"/>
              <pin name="1" x="5.08" y="0" length="point" rot="R90" direction="pas" visible="pad"/>
            </symbol>
            <symbol name="SYM_C5">
              <text x="-6.35" y="4.31" size="1.778" layer="95">&gt;NAME</text>
              <text x="-6.35" y="0.04" size="1.778" layer="96">&gt;VALUE</text>
              <pin name="1" x="5.08" y="0" length="point" rot="R90" direction="pas" visible="pad"/>
              <pin name="2" x="-5.08" y="0" length="point" rot="R90" direction="pas" visible="pad"/>
            </symbol>
            <symbol name="SYM_D9">
              <text x="-6.35" y="4.31" size="1.778" layer="95">&gt;NAME</text>
              <text x="-6.35" y="0.04" size="1.778" layer="96">&gt;VALUE</text>
              <pin name="2" x="5.08" y="0" length="point" rot="R90" direction="pas" visible="pad"/>
              <pin name="1" x="-5.08" y="0" length="point" rot="R90" direction="pas" visible="pad"/>
            </symbol>
            <symbol name="SYM_C6">
              <text x="-6.35" y="4.31" size="1.778" layer="95">&gt;NAME</text>
              <text x="-6.35" y="0.04" size="1.778" layer="96">&gt;VALUE</text>
              <pin name="1" x="5.08" y="0" length="point" rot="R90" direction="pas" visible="pad"/>
              <pin name="2" x="-5.08" y="0" length="point" rot="R90" direction="pas" visible="pad"/>
            </symbol>
            <symbol name="SYM_R6">
              <text x="-6.35" y="4.31" size="1.778" layer="95">&gt;NAME</text>
              <text x="-6.35" y="0.04" size="1.778" layer="96">&gt;VALUE</text>
              <pin name="2" x="-5.08" y="0" length="point" rot="R90" direction="pas" visible="pad"/>
              <pin name="1" x="5.08" y="0" length="point" rot="R90" direction="pas" visible="pad"/>
            </symbol>
            <symbol name="SYM_R18">
              <text x="-6.35" y="4.31" size="1.778" layer="95">&gt;NAME</text>
              <text x="-6.35" y="0.04" size="1.778" layer="96">&gt;VALUE</text>
              <pin name="2" x="-5.08" y="0" length="point" rot="R90" direction="pas" visible="pad"/>
              <pin name="1" x="5.08" y="0" length="point" rot="R90" direction="pas" visible="pad"/>
            </symbol>
            <symbol name="SYM_R8">
              <text x="-6.35" y="4.31" size="1.778" layer="95">&gt;NAME</text>
              <text x="-6.35" y="0.04" size="1.778" layer="96">&gt;VALUE</text>
              <pin name="2" x="-5.08" y="0" length="point" rot="R90" direction="pas" visible="pad"/>
              <pin name="1" x="5.08" y="0" length="point" rot="R90" direction="pas" visible="pad"/>
            </symbol>
            <symbol name="SYM_JUMPER">
              <text x="-6.35" y="4.31" size="1.778" layer="95">&gt;NAME</text>
              <text x="-6.35" y="0.04" size="1.778" layer="96">&gt;VALUE</text>
              <pin name="2" x="-5.08" y="0" length="point" rot="R90" direction="pas" visible="pad"/>
              <pin name="1" x="5.08" y="0" length="point" rot="R90" direction="pas" visible="pad"/>
            </symbol>
            <symbol name="SYM_U1">
              <wire x1="-19.05" y1="-33.02" x2="19.05" y2="-33.02" width="0.254" layer="94"/>
              <wire x1="19.05" y1="-33.02" x2="19.05" y2="12.7" width="0.254" layer="94"/>
              <wire x1="19.05" y1="12.7" x2="-19.05" y2="12.7" width="0.254" layer="94"/>
              <wire x1="-19.05" y1="12.7" x2="-19.05" y2="-33.02" width="0.254" layer="94"/>
              <text x="-19.05" y="13.2" size="1.778" layer="95">&gt;NAME</text>
              <text x="-19.05" y="-35.52" size="1.778" layer="96">&gt;VALUE</text>
              <pin name="1" x="-21.59" y="11.43" length="point" rot="R0" direction="pas" visible="pad"/>
              <pin name="2" x="-21.59" y="8.89" length="point" rot="R0" direction="pas" visible="pad"/>
              <pin name="3" x="-21.59" y="6.35" length="point" rot="R0" direction="pas" visible="pad"/>
              <pin name="4" x="-21.59" y="3.81" length="point" rot="R0" direction="pas" visible="pad"/>
              <pin name="5" x="-21.59" y="1.27" length="point" rot="R0" direction="pas" visible="pad"/>
              <pin name="6" x="-21.59" y="-1.27" length="point" rot="R0" direction="pas" visible="pad"/>
              <pin name="7" x="-21.59" y="-3.81" length="point" rot="R0" direction="pas" visible="pad"/>
              <pin name="8" x="-21.59" y="-6.35" length="point" rot="R0" direction="pas" visible="pad"/>
              <pin name="9" x="-21.59" y="-8.89" length="point" rot="R0" direction="pas" visible="pad"/>
              <pin name="10" x="-21.59" y="-11.43" length="point" rot="R0" direction="pas" visible="pad"/>
              <pin name="11" x="-21.59" y="-13.97" length="point" rot="R0" direction="pas" visible="pad"/>
              <pin name="12" x="-21.59" y="-16.51" length="point" rot="R0" direction="pas" visible="pad"/>
              <pin name="13" x="-21.59" y="-19.05" length="point" rot="R0" direction="pas" visible="pad"/>
              <pin name="14" x="-21.59" y="-21.59" length="point" rot="R0" direction="pas" visible="pad"/>
              <pin name="15" x="-12.7" y="-35.56" length="point" rot="R90" direction="pas" visible="pad"/>
              <pin name="16" x="-10.16" y="-35.56" length="point" rot="R90" direction="pas" visible="pad"/>
              <pin name="17" x="-7.62" y="-35.56" length="point" rot="R90" direction="pas" visible="pad"/>
              <pin name="18" x="-5.08" y="-35.56" length="point" rot="R90" direction="pas" visible="pad"/>
              <pin name="19" x="-2.54" y="-35.56" length="point" rot="R90" direction="pas" visible="pad"/>
              <pin name="20" x="0" y="-35.56" length="point" rot="R90" direction="pas" visible="pad"/>
              <pin name="21" x="2.54" y="-35.56" length="point" rot="R90" direction="pas" visible="pad"/>
              <pin name="22" x="5.08" y="-35.56" length="point" rot="R90" direction="pas" visible="pad"/>
              <pin name="23" x="7.62" y="-35.56" length="point" rot="R90" direction="pas" visible="pad"/>
              <pin name="24" x="10.16" y="-35.56" length="point" rot="R90" direction="pas" visible="pad"/>
              <pin name="25" x="12.7" y="-35.56" length="point" rot="R90" direction="pas" visible="pad"/>
              <pin name="26" x="15.24" y="-35.56" length="point" rot="R90" direction="pas" visible="pad"/>
              <pin name="27" x="21.59" y="-21.59" length="point" rot="R180" direction="pas" visible="pad"/>
              <pin name="28" x="21.59" y="-19.05" length="point" rot="R180" direction="pas" visible="pad"/>
              <pin name="29" x="21.59" y="-16.51" length="point" rot="R180" direction="pas" visible="pad"/>
              <pin name="30" x="21.59" y="-13.97" length="point" rot="R180" direction="pas" visible="pad"/>
              <pin name="31" x="21.59" y="-11.43" length="point" rot="R180" direction="pas" visible="pad"/>
              <pin name="32" x="21.59" y="-8.89" length="point" rot="R180" direction="pas" visible="pad"/>
              <pin name="33" x="21.59" y="-6.35" length="point" rot="R180" direction="pas" visible="pad"/>
              <pin name="34" x="21.59" y="-3.81" length="point" rot="R180" direction="pas" visible="pad"/>
              <pin name="35" x="21.59" y="-1.27" length="point" rot="R180" direction="pas" visible="pad"/>
              <pin name="36" x="21.59" y="1.27" length="point" rot="R180" direction="pas" visible="pad"/>
              <pin name="37" x="21.59" y="3.81" length="point" rot="R180" direction="pas" visible="pad"/>
              <pin name="38" x="21.59" y="6.35" length="point" rot="R180" direction="pas" visible="pad"/>
              <pin name="39" x="21.59" y="8.89" length="point" rot="R180" direction="pas" visible="pad"/>
              <pin name="40" x="21.59" y="11.43" length="point" rot="R180" direction="pas" visible="pad"/>
              <pin name="41" x="21.59" y="15.24" length="point" rot="R270" direction="pas" visible="pad"/>
            </symbol>
            <symbol name="SYM_C13">
              <text x="-6.35" y="4.31" size="1.778" layer="95">&gt;NAME</text>
              <text x="-6.35" y="0.04" size="1.778" layer="96">&gt;VALUE</text>
              <pin name="1" x="5.08" y="0" length="point" rot="R90" direction="pas" visible="pad"/>
              <pin name="2" x="-5.08" y="0" length="point" rot="R90" direction="pas" visible="pad"/>
            </symbol>
            <symbol name="SYM_R9">
              <text x="-6.35" y="4.31" size="1.778" layer="95">&gt;NAME</text>
              <text x="-6.35" y="0.04" size="1.778" layer="96">&gt;VALUE</text>
              <pin name="2" x="-5.08" y="0" length="point" rot="R90" direction="pas" visible="pad"/>
              <pin name="1" x="5.08" y="0" length="point" rot="R90" direction="pas" visible="pad"/>
            </symbol>
            <symbol name="SYM_U4">
              <wire x1="-1.27" y1="-1.27" x2="1.27" y2="-1.27" width="0.254" layer="94"/>
              <wire x1="1.27" y1="-1.27" x2="1.27" y2="1.27" width="0.254" layer="94"/>
              <wire x1="1.27" y1="1.27" x2="-1.27" y2="1.27" width="0.254" layer="94"/>
              <wire x1="-1.27" y1="1.27" x2="-1.27" y2="-1.27" width="0.254" layer="94"/>
              <text x="-1.27" y="1.77" size="1.778" layer="95">&gt;NAME</text>
              <text x="-1.27" y="-3.77" size="1.778" layer="96">&gt;VALUE</text>
              <pin name="1" x="-11.43" y="2.54" length="point" rot="R0" direction="pas" visible="pad"/>
              <pin name="2" x="-11.43" y="0" length="point" rot="R0" direction="pas" visible="pad"/>
              <pin name="3" x="-11.43" y="-2.54" length="point" rot="R0" direction="pas" visible="pad"/>
              <pin name="4" x="11.43" y="-2.54" length="point" rot="R180" direction="pas" visible="pad"/>
              <pin name="5" x="11.43" y="0" length="point" rot="R180" direction="pas" visible="pad"/>
              <pin name="6" x="11.43" y="2.54" length="point" rot="R180" direction="pas" visible="pad"/>
            </symbol>
            <symbol name="SYM_D4">
              <text x="-6.35" y="4.31" size="1.778" layer="95">&gt;NAME</text>
              <text x="-6.35" y="0.04" size="1.778" layer="96">&gt;VALUE</text>
              <pin name="2" x="-5.08" y="-0" length="point" rot="R90" direction="pas" visible="pad"/>
              <pin name="1" x="5.08" y="-0" length="point" rot="R90" direction="pas" visible="pad"/>
            </symbol>
            <symbol name="SYM_C7">
              <text x="-5.08" y="4.31" size="1.778" layer="95">&gt;NAME</text>
              <text x="-5.08" y="0.04" size="1.778" layer="96">&gt;VALUE</text>
              <pin name="1" x="3.81" y="0" length="point" rot="R90" direction="pas" visible="pad"/>
              <pin name="2" x="-3.81" y="0" length="point" rot="R90" direction="pas" visible="pad"/>
            </symbol>
            <symbol name="SYM_D8">
              <text x="-6.35" y="4.31" size="1.778" layer="95">&gt;NAME</text>
              <text x="-6.35" y="0.04" size="1.778" layer="96">&gt;VALUE</text>
              <pin name="2" x="5.08" y="0" length="point" rot="R90" direction="pas" visible="pad"/>
              <pin name="1" x="-5.08" y="0" length="point" rot="R90" direction="pas" visible="pad"/>
            </symbol>
            <symbol name="SYM_D10">
              <text x="-6.35" y="4.31" size="1.778" layer="95">&gt;NAME</text>
              <text x="-6.35" y="0.04" size="1.778" layer="96">&gt;VALUE</text>
              <pin name="2" x="5.08" y="0" length="point" rot="R90" direction="pas" visible="pad"/>
              <pin name="1" x="-5.08" y="0" length="point" rot="R90" direction="pas" visible="pad"/>
            </symbol>
            <symbol name="SYM_D11">
              <text x="-6.35" y="4.31" size="1.778" layer="95">&gt;NAME</text>
              <text x="-6.35" y="0.04" size="1.778" layer="96">&gt;VALUE</text>
              <pin name="2" x="5.08" y="0" length="point" rot="R90" direction="pas" visible="pad"/>
              <pin name="1" x="-5.08" y="0" length="point" rot="R90" direction="pas" visible="pad"/>
            </symbol>
            <symbol name="SYM_R19">
              <text x="-6.35" y="4.31" size="1.778" layer="95">&gt;NAME</text>
              <text x="-6.35" y="0.04" size="1.778" layer="96">&gt;VALUE</text>
              <pin name="2" x="-5.08" y="-0" length="point" rot="R90" direction="pas" visible="pad"/>
              <pin name="1" x="5.08" y="-0" length="point" rot="R90" direction="pas" visible="pad"/>
            </symbol>
            <symbol name="SYM_USBC">
              <wire x1="-10.16" y1="-10.16" x2="7.62" y2="-10.16" width="0.254" layer="94"/>
              <wire x1="7.62" y1="-10.16" x2="7.62" y2="12.7" width="0.254" layer="94"/>
              <wire x1="7.62" y1="12.7" x2="-10.16" y2="12.7" width="0.254" layer="94"/>
              <wire x1="-10.16" y1="12.7" x2="-10.16" y2="-10.16" width="0.254" layer="94"/>
              <text x="-10.16" y="13.2" size="1.778" layer="95">&gt;NAME</text>
              <text x="-10.16" y="-12.66" size="1.778" layer="96">&gt;VALUE</text>
              <pin name="4" x="10.16" y="15.24" length="point" rot="R270" direction="pas" visible="pad"/>
              <pin name="3" x="10.16" y="12.7" length="point" rot="R180" direction="pas" visible="pad"/>
              <pin name="2" x="10.16" y="-10.16" length="point" rot="R180" direction="pas" visible="pad"/>
              <pin name="1" x="10.16" y="-12.7" length="point" rot="R180" direction="pas" visible="pad"/>
              <pin name="B1A12" x="-12.7" y="-12.7" length="point" rot="R0" direction="pas" visible="pad"/>
              <pin name="B4A9" x="-12.7" y="-10.16" length="point" rot="R0" direction="pas" visible="pad"/>
              <pin name="B5" x="-12.7" y="-7.62" length="point" rot="R0" direction="pas" visible="pad"/>
              <pin name="A8" x="-12.7" y="-5.08" length="point" rot="R0" direction="pas" visible="pad"/>
              <pin name="B6" x="-12.7" y="-2.54" length="point" rot="R0" direction="pas" visible="pad"/>
              <pin name="A7" x="-12.7" y="-0" length="point" rot="R0" direction="pas" visible="pad"/>
              <pin name="A6" x="-12.7" y="2.54" length="point" rot="R0" direction="pas" visible="pad"/>
              <pin name="B7" x="-12.7" y="5.08" length="point" rot="R0" direction="pas" visible="pad"/>
              <pin name="A5" x="-12.7" y="7.62" length="point" rot="R0" direction="pas" visible="pad"/>
              <pin name="B8" x="-12.7" y="10.16" length="point" rot="R0" direction="pas" visible="pad"/>
              <pin name="A4B9" x="-12.7" y="12.7" length="point" rot="R0" direction="pas" visible="pad"/>
              <pin name="A1B12" x="-12.7" y="15.24" length="point" rot="R270" direction="pas" visible="pad"/>
            </symbol>
            <symbol name="SYM_R11">
              <text x="-6.35" y="4.31" size="1.778" layer="95">&gt;NAME</text>
              <text x="-6.35" y="0.04" size="1.778" layer="96">&gt;VALUE</text>
              <pin name="2" x="-5.08" y="0" length="point" rot="R90" direction="pas" visible="pad"/>
              <pin name="1" x="5.08" y="0" length="point" rot="R90" direction="pas" visible="pad"/>
            </symbol>
            <symbol name="SYM_R12">
              <text x="-6.35" y="4.31" size="1.778" layer="95">&gt;NAME</text>
              <text x="-6.35" y="0.04" size="1.778" layer="96">&gt;VALUE</text>
              <pin name="2" x="-5.08" y="0" length="point" rot="R90" direction="pas" visible="pad"/>
              <pin name="1" x="5.08" y="0" length="point" rot="R90" direction="pas" visible="pad"/>
            </symbol>
          </symbols>
          <devicesets>
            <deviceset name="DS_SPI" prefix="" uservalue="yes">
              <description>HDR-M-2.54_1x3</description>
              <gates>
                <gate name="G$1" symbol="SYM_SPI" x="0" y="0"/>
              </gates>
              <devices>
                <device name="">
                  <technologies>
                    <technology name=""/>
                  </technologies>
                </device>
              </devices>
            </deviceset>
            <deviceset name="DS_R15" prefix="" uservalue="yes">
              <description>0402WGF1001TCE</description>
              <gates>
                <gate name="G$1" symbol="SYM_R15" x="0" y="0"/>
              </gates>
              <devices>
                <device name="">
                  <technologies>
                    <technology name=""/>
                  </technologies>
                </device>
              </devices>
            </deviceset>
            <deviceset name="DS_POWER" prefix="" uservalue="yes">
              <description>HDR-M-2.54_1x2</description>
              <gates>
                <gate name="G$1" symbol="SYM_POWER" x="0" y="0"/>
              </gates>
              <devices>
                <device name="">
                  <technologies>
                    <technology name=""/>
                  </technologies>
                </device>
              </devices>
            </deviceset>
            <deviceset name="DS_GPIO" prefix="" uservalue="yes">
              <description>HDR-M-2.54_1x4</description>
              <gates>
                <gate name="G$1" symbol="SYM_GPIO" x="0" y="0"/>
              </gates>
              <devices>
                <device name="">
                  <technologies>
                    <technology name=""/>
                  </technologies>
                </device>
              </devices>
            </deviceset>
            <deviceset name="DS_I2C" prefix="" uservalue="yes">
              <description>HDR-M-2.54_1x4</description>
              <gates>
                <gate name="G$1" symbol="SYM_I2C" x="0" y="0"/>
              </gates>
              <devices>
                <device name="">
                  <technologies>
                    <technology name=""/>
                  </technologies>
                </device>
              </devices>
            </deviceset>
            <deviceset name="DS_CAN" prefix="" uservalue="yes">
              <description>HDR-M-2.54_1x2</description>
              <gates>
                <gate name="G$1" symbol="SYM_CAN" x="0" y="0"/>
              </gates>
              <devices>
                <device name="">
                  <technologies>
                    <technology name=""/>
                  </technologies>
                </device>
              </devices>
            </deviceset>
            <deviceset name="DS_YELLOW" prefix="" uservalue="yes">
              <description>19-213/Y2C-CQ2R2L/3T(CY)</description>
              <gates>
                <gate name="G$1" symbol="SYM_YELLOW" x="0" y="0"/>
              </gates>
              <devices>
                <device name="">
                  <technologies>
                    <technology name=""/>
                  </technologies>
                </device>
              </devices>
            </deviceset>
            <deviceset name="DS_BLUE" prefix="" uservalue="yes">
              <description>19-217/BHC-ZL1M2RY/3T</description>
              <gates>
                <gate name="G$1" symbol="SYM_BLUE" x="0" y="0"/>
              </gates>
              <devices>
                <device name="">
                  <technologies>
                    <technology name=""/>
                  </technologies>
                </device>
              </devices>
            </deviceset>
            <deviceset name="DS_GREEN" prefix="" uservalue="yes">
              <description>19-217/GHC-YR1S2/3T</description>
              <gates>
                <gate name="G$1" symbol="SYM_GREEN" x="0" y="0"/>
              </gates>
              <devices>
                <device name="">
                  <technologies>
                    <technology name=""/>
                  </technologies>
                </device>
              </devices>
            </deviceset>
            <deviceset name="DS_R13" prefix="" uservalue="yes">
              <description>0402WGF2201TCE</description>
              <gates>
                <gate name="G$1" symbol="SYM_R13" x="0" y="0"/>
              </gates>
              <devices>
                <device name="">
                  <technologies>
                    <technology name=""/>
                  </technologies>
                </device>
              </devices>
            </deviceset>
            <deviceset name="DS_R14" prefix="" uservalue="yes">
              <description>0402WGF4700TCE</description>
              <gates>
                <gate name="G$1" symbol="SYM_R14" x="0" y="0"/>
              </gates>
              <devices>
                <device name="">
                  <technologies>
                    <technology name=""/>
                  </technologies>
                </device>
              </devices>
            </deviceset>
            <deviceset name="DS_PROG" prefix="" uservalue="yes">
              <description>GT-TC029B-H025-L1N</description>
              <gates>
                <gate name="G$1" symbol="SYM_PROG" x="0" y="0"/>
              </gates>
              <devices>
                <device name="">
                  <technologies>
                    <technology name=""/>
                  </technologies>
                </device>
              </devices>
            </deviceset>
            <deviceset name="DS_R7" prefix="" uservalue="yes">
              <description>0402WGF1002TCE</description>
              <gates>
                <gate name="G$1" symbol="SYM_R7" x="0" y="0"/>
              </gates>
              <devices>
                <device name="">
                  <technologies>
                    <technology name=""/>
                  </technologies>
                </device>
              </devices>
            </deviceset>
            <deviceset name="DS_R5" prefix="" uservalue="yes">
              <description>0402WGF3302TCE</description>
              <gates>
                <gate name="G$1" symbol="SYM_R5" x="0" y="0"/>
              </gates>
              <devices>
                <device name="">
                  <technologies>
                    <technology name=""/>
                  </technologies>
                </device>
              </devices>
            </deviceset>
            <deviceset name="DS_Q1" prefix="" uservalue="yes">
              <description>SS8050</description>
              <gates>
                <gate name="G$1" symbol="SYM_Q1" x="0" y="0"/>
              </gates>
              <devices>
                <device name="">
                  <technologies>
                    <technology name=""/>
                  </technologies>
                </device>
              </devices>
            </deviceset>
            <deviceset name="DS_U3" prefix="" uservalue="yes">
              <description>ME2807A33M3G</description>
              <gates>
                <gate name="G$1" symbol="SYM_U3" x="0" y="0"/>
              </gates>
              <devices>
                <device name="">
                  <technologies>
                    <technology name=""/>
                  </technologies>
                </device>
              </devices>
            </deviceset>
            <deviceset name="DS_L1" prefix="" uservalue="yes">
              <description>SLP6028S100MTT</description>
              <gates>
                <gate name="G$1" symbol="SYM_L1" x="0" y="0"/>
              </gates>
              <devices>
                <device name="">
                  <technologies>
                    <technology name=""/>
                  </technologies>
                </device>
              </devices>
            </deviceset>
            <deviceset name="DS_R16" prefix="" uservalue="yes">
              <description>0402WGF1202TCE</description>
              <gates>
                <gate name="G$1" symbol="SYM_R16" x="0" y="0"/>
              </gates>
              <devices>
                <device name="">
                  <technologies>
                    <technology name=""/>
                  </technologies>
                </device>
              </devices>
            </deviceset>
            <deviceset name="DS_C12" prefix="" uservalue="yes">
              <description>CL10A226MQ8NRNC</description>
              <gates>
                <gate name="G$1" symbol="SYM_C12" x="0" y="0"/>
              </gates>
              <devices>
                <device name="">
                  <technologies>
                    <technology name=""/>
                  </technologies>
                </device>
              </devices>
            </deviceset>
            <deviceset name="DS_C11" prefix="" uservalue="yes">
              <description>CL10A226MQ8NRNC</description>
              <gates>
                <gate name="G$1" symbol="SYM_C11" x="0" y="0"/>
              </gates>
              <devices>
                <device name="">
                  <technologies>
                    <technology name=""/>
                  </technologies>
                </device>
              </devices>
            </deviceset>
            <deviceset name="DS_U5" prefix="" uservalue="yes">
              <description>MT9700</description>
              <gates>
                <gate name="G$1" symbol="SYM_U5" x="0" y="0"/>
              </gates>
              <devices>
                <device name="">
                  <technologies>
                    <technology name=""/>
                  </technologies>
                </device>
              </devices>
            </deviceset>
            <deviceset name="DS_R10" prefix="" uservalue="yes">
              <description>0402WGF1002TCE</description>
              <gates>
                <gate name="G$1" symbol="SYM_R10" x="0" y="0"/>
              </gates>
              <devices>
                <device name="">
                  <technologies>
                    <technology name=""/>
                  </technologies>
                </device>
              </devices>
            </deviceset>
            <deviceset name="DS_D5" prefix="" uservalue="yes">
              <description>SS34</description>
              <gates>
                <gate name="G$1" symbol="SYM_D5" x="0" y="0"/>
              </gates>
              <devices>
                <device name="">
                  <technologies>
                    <technology name=""/>
                  </technologies>
                </device>
              </devices>
            </deviceset>
            <deviceset name="DS_D2" prefix="" uservalue="yes">
              <description>1N4148WS T4</description>
              <gates>
                <gate name="G$1" symbol="SYM_D2" x="0" y="0"/>
              </gates>
              <devices>
                <device name="">
                  <technologies>
                    <technology name=""/>
                  </technologies>
                </device>
              </devices>
            </deviceset>
            <deviceset name="DS_D3" prefix="" uservalue="yes">
              <description>1N4148WS T4</description>
              <gates>
                <gate name="G$1" symbol="SYM_D3" x="0" y="0"/>
              </gates>
              <devices>
                <device name="">
                  <technologies>
                    <technology name=""/>
                  </technologies>
                </device>
              </devices>
            </deviceset>
            <deviceset name="DS_D1" prefix="" uservalue="yes">
              <description>1N4148WS T4</description>
              <gates>
                <gate name="G$1" symbol="SYM_D1" x="0" y="0"/>
              </gates>
              <devices>
                <device name="">
                  <technologies>
                    <technology name=""/>
                  </technologies>
                </device>
              </devices>
            </deviceset>
            <deviceset name="DS_RESET" prefix="" uservalue="yes">
              <description>GT-TC029B-H025-L1N</description>
              <gates>
                <gate name="G$1" symbol="SYM_RESET" x="0" y="0"/>
              </gates>
              <devices>
                <device name="">
                  <technologies>
                    <technology name=""/>
                  </technologies>
                </device>
              </devices>
            </deviceset>
            <deviceset name="DS_R3" prefix="" uservalue="yes">
              <description>0402WGF1002TCE</description>
              <gates>
                <gate name="G$1" symbol="SYM_R3" x="0" y="0"/>
              </gates>
              <devices>
                <device name="">
                  <technologies>
                    <technology name=""/>
                  </technologies>
                </device>
              </devices>
            </deviceset>
            <deviceset name="DS_C1" prefix="" uservalue="yes">
              <description>TAJB107K006RNJ</description>
              <gates>
                <gate name="G$1" symbol="SYM_C1" x="0" y="0"/>
              </gates>
              <devices>
                <device name="">
                  <technologies>
                    <technology name=""/>
                  </technologies>
                </device>
              </devices>
            </deviceset>
            <deviceset name="DS_C4" prefix="" uservalue="yes">
              <description>CL05B104KO5NNNC</description>
              <gates>
                <gate name="G$1" symbol="SYM_C4" x="0" y="0"/>
              </gates>
              <devices>
                <device name="">
                  <technologies>
                    <technology name=""/>
                  </technologies>
                </device>
              </devices>
            </deviceset>
            <deviceset name="DS_C2" prefix="" uservalue="yes">
              <description>CL05B104KO5NNNC</description>
              <gates>
                <gate name="G$1" symbol="SYM_C2" x="0" y="0"/>
              </gates>
              <devices>
                <device name="">
                  <technologies>
                    <technology name=""/>
                  </technologies>
                </device>
              </devices>
            </deviceset>
            <deviceset name="DS_R1" prefix="" uservalue="yes">
              <description>0402WGF1002TCE</description>
              <gates>
                <gate name="G$1" symbol="SYM_R1" x="0" y="0"/>
              </gates>
              <devices>
                <device name="">
                  <technologies>
                    <technology name=""/>
                  </technologies>
                </device>
              </devices>
            </deviceset>
            <deviceset name="DS_C3" prefix="" uservalue="yes">
              <description>CL05A105KA5NQNC</description>
              <gates>
                <gate name="G$1" symbol="SYM_C3" x="0" y="0"/>
              </gates>
              <devices>
                <device name="">
                  <technologies>
                    <technology name=""/>
                  </technologies>
                </device>
              </devices>
            </deviceset>
            <deviceset name="DS_U2" prefix="" uservalue="yes">
              <description>SN65HVD230DR</description>
              <gates>
                <gate name="G$1" symbol="SYM_U2" x="0" y="0"/>
              </gates>
              <devices>
                <device name="">
                  <technologies>
                    <technology name=""/>
                  </technologies>
                </device>
              </devices>
            </deviceset>
            <deviceset name="DS_TERMINATION" prefix="" uservalue="yes">
              <description>HDR-M-2.54_1x2</description>
              <gates>
                <gate name="G$1" symbol="SYM_TERMINATION" x="0" y="0"/>
              </gates>
              <devices>
                <device name="">
                  <technologies>
                    <technology name=""/>
                  </technologies>
                </device>
              </devices>
            </deviceset>
            <deviceset name="DS_R2" prefix="" uservalue="yes">
              <description>RTT061200FTP</description>
              <gates>
                <gate name="G$1" symbol="SYM_R2" x="0" y="0"/>
              </gates>
              <devices>
                <device name="">
                  <technologies>
                    <technology name=""/>
                  </technologies>
                </device>
              </devices>
            </deviceset>
            <deviceset name="DS_F1" prefix="" uservalue="yes">
              <description>MF-MSMF110/16-2</description>
              <gates>
                <gate name="G$1" symbol="SYM_F1" x="0" y="0"/>
              </gates>
              <devices>
                <device name="">
                  <technologies>
                    <technology name=""/>
                  </technologies>
                </device>
              </devices>
            </deviceset>
            <deviceset name="DS_R17" prefix="" uservalue="yes">
              <description>0402WGF1002TCE</description>
              <gates>
                <gate name="G$1" symbol="SYM_R17" x="0" y="0"/>
              </gates>
              <devices>
                <device name="">
                  <technologies>
                    <technology name=""/>
                  </technologies>
                </device>
              </devices>
            </deviceset>
            <deviceset name="DS_C10" prefix="" uservalue="yes">
              <description>CL10A226MQ8NRNC</description>
              <gates>
                <gate name="G$1" symbol="SYM_C10" x="0" y="0"/>
              </gates>
              <devices>
                <device name="">
                  <technologies>
                    <technology name=""/>
                  </technologies>
                </device>
              </devices>
            </deviceset>
            <deviceset name="DS_C8" prefix="" uservalue="yes">
              <description>CL10A226MQ8NRNC</description>
              <gates>
                <gate name="G$1" symbol="SYM_C8" x="0" y="0"/>
              </gates>
              <devices>
                <device name="">
                  <technologies>
                    <technology name=""/>
                  </technologies>
                </device>
              </devices>
            </deviceset>
            <deviceset name="DS_C9" prefix="" uservalue="yes">
              <description>CL10A226MQ8NRNC</description>
              <gates>
                <gate name="G$1" symbol="SYM_C9" x="0" y="0"/>
              </gates>
              <devices>
                <device name="">
                  <technologies>
                    <technology name=""/>
                  </technologies>
                </device>
              </devices>
            </deviceset>
            <deviceset name="DS_D6" prefix="" uservalue="yes">
              <description>DSS34</description>
              <gates>
                <gate name="G$1" symbol="SYM_D6" x="0" y="0"/>
              </gates>
              <devices>
                <device name="">
                  <technologies>
                    <technology name=""/>
                  </technologies>
                </device>
              </devices>
            </deviceset>
            <deviceset name="DS_D7" prefix="" uservalue="yes">
              <description>DSS34</description>
              <gates>
                <gate name="G$1" symbol="SYM_D7" x="0" y="0"/>
              </gates>
              <devices>
                <device name="">
                  <technologies>
                    <technology name=""/>
                  </technologies>
                </device>
              </devices>
            </deviceset>
            <deviceset name="DS_SD-CARD" prefix="" uservalue="yes">
              <description>MR01A-01211</description>
              <gates>
                <gate name="G$1" symbol="SYM_SD-CARD" x="0" y="0"/>
              </gates>
              <devices>
                <device name="">
                  <technologies>
                    <technology name=""/>
                  </technologies>
                </device>
              </devices>
            </deviceset>
            <deviceset name="DS_R4" prefix="" uservalue="yes">
              <description>0402WGF9102TCE</description>
              <gates>
                <gate name="G$1" symbol="SYM_R4" x="0" y="0"/>
              </gates>
              <devices>
                <device name="">
                  <technologies>
                    <technology name=""/>
                  </technologies>
                </device>
              </devices>
            </deviceset>
            <deviceset name="DS_C5" prefix="" uservalue="yes">
              <description>CL05A105KA5NQNC</description>
              <gates>
                <gate name="G$1" symbol="SYM_C5" x="0" y="0"/>
              </gates>
              <devices>
                <device name="">
                  <technologies>
                    <technology name=""/>
                  </technologies>
                </device>
              </devices>
            </deviceset>
            <deviceset name="DS_D9" prefix="" uservalue="yes">
              <description>1N4148WS T4</description>
              <gates>
                <gate name="G$1" symbol="SYM_D9" x="0" y="0"/>
              </gates>
              <devices>
                <device name="">
                  <technologies>
                    <technology name=""/>
                  </technologies>
                </device>
              </devices>
            </deviceset>
            <deviceset name="DS_C6" prefix="" uservalue="yes">
              <description>CL21A226MAYNNNE</description>
              <gates>
                <gate name="G$1" symbol="SYM_C6" x="0" y="0"/>
              </gates>
              <devices>
                <device name="">
                  <technologies>
                    <technology name=""/>
                  </technologies>
                </device>
              </devices>
            </deviceset>
            <deviceset name="DS_R6" prefix="" uservalue="yes">
              <description>0402WGF3302TCE</description>
              <gates>
                <gate name="G$1" symbol="SYM_R6" x="0" y="0"/>
              </gates>
              <devices>
                <device name="">
                  <technologies>
                    <technology name=""/>
                  </technologies>
                </device>
              </devices>
            </deviceset>
            <deviceset name="DS_R18" prefix="" uservalue="yes">
              <description>0402WGF1203TCE</description>
              <gates>
                <gate name="G$1" symbol="SYM_R18" x="0" y="0"/>
              </gates>
              <devices>
                <device name="">
                  <technologies>
                    <technology name=""/>
                  </technologies>
                </device>
              </devices>
            </deviceset>
            <deviceset name="DS_R8" prefix="" uservalue="yes">
              <description>0402WGF1002TCE</description>
              <gates>
                <gate name="G$1" symbol="SYM_R8" x="0" y="0"/>
              </gates>
              <devices>
                <device name="">
                  <technologies>
                    <technology name=""/>
                  </technologies>
                </device>
              </devices>
            </deviceset>
            <deviceset name="DS_JUMPER" prefix="" uservalue="yes">
              <description>-</description>
              <gates>
                <gate name="G$1" symbol="SYM_JUMPER" x="0" y="0"/>
              </gates>
              <devices>
                <device name="">
                  <technologies>
                    <technology name=""/>
                  </technologies>
                </device>
              </devices>
            </deviceset>
            <deviceset name="DS_U1" prefix="" uservalue="yes">
              <description>ESP32-S3-WROOM-1(N16R8)</description>
              <gates>
                <gate name="G$1" symbol="SYM_U1" x="0" y="0"/>
              </gates>
              <devices>
                <device name="">
                  <technologies>
                    <technology name=""/>
                  </technologies>
                </device>
              </devices>
            </deviceset>
            <deviceset name="DS_C13" prefix="" uservalue="yes">
              <description>CL05B104KB54PNC</description>
              <gates>
                <gate name="G$1" symbol="SYM_C13" x="0" y="0"/>
              </gates>
              <devices>
                <device name="">
                  <technologies>
                    <technology name=""/>
                  </technologies>
                </device>
              </devices>
            </deviceset>
            <deviceset name="DS_R9" prefix="" uservalue="yes">
              <description>0402WGF3302TCE</description>
              <gates>
                <gate name="G$1" symbol="SYM_R9" x="0" y="0"/>
              </gates>
              <devices>
                <device name="">
                  <technologies>
                    <technology name=""/>
                  </technologies>
                </device>
              </devices>
            </deviceset>
            <deviceset name="DS_U4" prefix="" uservalue="yes">
              <description>LMR14006XDDCR</description>
              <gates>
                <gate name="G$1" symbol="SYM_U4" x="0" y="0"/>
              </gates>
              <devices>
                <device name="">
                  <technologies>
                    <technology name=""/>
                  </technologies>
                </device>
              </devices>
            </deviceset>
            <deviceset name="DS_D4" prefix="" uservalue="yes">
              <description>SMF30A</description>
              <gates>
                <gate name="G$1" symbol="SYM_D4" x="0" y="0"/>
              </gates>
              <devices>
                <device name="">
                  <technologies>
                    <technology name=""/>
                  </technologies>
                </device>
              </devices>
            </deviceset>
            <deviceset name="DS_C7" prefix="" uservalue="yes">
              <description>CL05B104KO5NNNC</description>
              <gates>
                <gate name="G$1" symbol="SYM_C7" x="0" y="0"/>
              </gates>
              <devices>
                <device name="">
                  <technologies>
                    <technology name=""/>
                  </technologies>
                </device>
              </devices>
            </deviceset>
            <deviceset name="DS_D8" prefix="" uservalue="yes">
              <description>LESD5D5.0CT1G</description>
              <gates>
                <gate name="G$1" symbol="SYM_D8" x="0" y="0"/>
              </gates>
              <devices>
                <device name="">
                  <technologies>
                    <technology name=""/>
                  </technologies>
                </device>
              </devices>
            </deviceset>
            <deviceset name="DS_D10" prefix="" uservalue="yes">
              <description>LESD5D5.0CT1G</description>
              <gates>
                <gate name="G$1" symbol="SYM_D10" x="0" y="0"/>
              </gates>
              <devices>
                <device name="">
                  <technologies>
                    <technology name=""/>
                  </technologies>
                </device>
              </devices>
            </deviceset>
            <deviceset name="DS_D11" prefix="" uservalue="yes">
              <description>LESD5D5.0CT1G</description>
              <gates>
                <gate name="G$1" symbol="SYM_D11" x="0" y="0"/>
              </gates>
              <devices>
                <device name="">
                  <technologies>
                    <technology name=""/>
                  </technologies>
                </device>
              </devices>
            </deviceset>
            <deviceset name="DS_R19" prefix="" uservalue="yes">
              <description>0402WGF9102TCE</description>
              <gates>
                <gate name="G$1" symbol="SYM_R19" x="0" y="0"/>
              </gates>
              <devices>
                <device name="">
                  <technologies>
                    <technology name=""/>
                  </technologies>
                </device>
              </devices>
            </deviceset>
            <deviceset name="DS_USBC" prefix="" uservalue="yes">
              <description>GT-USB-7010ASV</description>
              <gates>
                <gate name="G$1" symbol="SYM_USBC" x="0" y="0"/>
              </gates>
              <devices>
                <device name="">
                  <technologies>
                    <technology name=""/>
                  </technologies>
                </device>
              </devices>
            </deviceset>
            <deviceset name="DS_R11" prefix="" uservalue="yes">
              <description>0402WGF5101TCE</description>
              <gates>
                <gate name="G$1" symbol="SYM_R11" x="0" y="0"/>
              </gates>
              <devices>
                <device name="">
                  <technologies>
                    <technology name=""/>
                  </technologies>
                </device>
              </devices>
            </deviceset>
            <deviceset name="DS_R12" prefix="" uservalue="yes">
              <description>0402WGF5101TCE</description>
              <gates>
                <gate name="G$1" symbol="SYM_R12" x="0" y="0"/>
              </gates>
              <devices>
                <device name="">
                  <technologies>
                    <technology name=""/>
                  </technologies>
                </device>
              </devices>
            </deviceset>
          </devicesets>
        </library>
      </libraries>
      <attributes/>
      <variantdefs/>
      <classes>
        <class number="0" name="default" width="0" drill="0"/>
      </classes>
      <parts>
        <part name="SPI" library="rejsacan_synth" deviceset="DS_SPI" device="" value="HDR-M-2.54_1x3"/>
        <part name="R15" library="rejsacan_synth" deviceset="DS_R15" device="" value="1K"/>
        <part name="POWER" library="rejsacan_synth" deviceset="DS_POWER" device="" value="HDR-M-2.54_1x2"/>
        <part name="GPIO" library="rejsacan_synth" deviceset="DS_GPIO" device="" value="HDR-M-2.54_1x4"/>
        <part name="I2C" library="rejsacan_synth" deviceset="DS_I2C" device="" value="HDR-M-2.54_1x4"/>
        <part name="CAN" library="rejsacan_synth" deviceset="DS_CAN" device="" value="HDR-M-2.54_1x2"/>
        <part name="YELLOW" library="rejsacan_synth" deviceset="DS_YELLOW" device="" value="19-213/Y2C-CQ2R2L/3T(CY)"/>
        <part name="BLUE" library="rejsacan_synth" deviceset="DS_BLUE" device="" value="19-217/BHC-ZL1M2RY/3T"/>
        <part name="GREEN" library="rejsacan_synth" deviceset="DS_GREEN" device="" value="19-217/GHC-YR1S2/3T"/>
        <part name="R13" library="rejsacan_synth" deviceset="DS_R13" device="" value="2.2K"/>
        <part name="R14" library="rejsacan_synth" deviceset="DS_R14" device="" value="500"/>
        <part name="PROG" library="rejsacan_synth" deviceset="DS_PROG" device="" value="GT-TC029B-H025-L1N"/>
        <part name="R7" library="rejsacan_synth" deviceset="DS_R7" device="" value="10K"/>
        <part name="R5" library="rejsacan_synth" deviceset="DS_R5" device="" value="33K"/>
        <part name="Q1" library="rejsacan_synth" deviceset="DS_Q1" device="" value="SS8050"/>
        <part name="U3" library="rejsacan_synth" deviceset="DS_U3" device="" value="ME2807A33M3G"/>
        <part name="L1" library="rejsacan_synth" deviceset="DS_L1" device="" value="10uH"/>
        <part name="R16" library="rejsacan_synth" deviceset="DS_R16" device="" value="12K"/>
        <part name="C12" library="rejsacan_synth" deviceset="DS_C12" device="" value="22uF"/>
        <part name="C11" library="rejsacan_synth" deviceset="DS_C11" device="" value="22uF"/>
        <part name="U5" library="rejsacan_synth" deviceset="DS_U5" device="" value="MT9700"/>
        <part name="R10" library="rejsacan_synth" deviceset="DS_R10" device="" value="10K"/>
        <part name="D5" library="rejsacan_synth" deviceset="DS_D5" device="" value="SS34"/>
        <part name="D2" library="rejsacan_synth" deviceset="DS_D2" device="" value="1N4148"/>
        <part name="D3" library="rejsacan_synth" deviceset="DS_D3" device="" value="1N4148"/>
        <part name="D1" library="rejsacan_synth" deviceset="DS_D1" device="" value="1N4148"/>
        <part name="RESET" library="rejsacan_synth" deviceset="DS_RESET" device="" value="GT-TC029B-H025-L1N"/>
        <part name="R3" library="rejsacan_synth" deviceset="DS_R3" device="" value="10K"/>
        <part name="C1" library="rejsacan_synth" deviceset="DS_C1" device="" value="100uF"/>
        <part name="C4" library="rejsacan_synth" deviceset="DS_C4" device="" value="100nF"/>
        <part name="C2" library="rejsacan_synth" deviceset="DS_C2" device="" value="100nF"/>
        <part name="R1" library="rejsacan_synth" deviceset="DS_R1" device="" value="10K"/>
        <part name="C3" library="rejsacan_synth" deviceset="DS_C3" device="" value="1uF"/>
        <part name="U2" library="rejsacan_synth" deviceset="DS_U2" device="" value="SN65HVD230DR"/>
        <part name="TERMINATION" library="rejsacan_synth" deviceset="DS_TERMINATION" device="" value="HDR-M-2.54_1x2"/>
        <part name="R2" library="rejsacan_synth" deviceset="DS_R2" device="" value="120"/>
        <part name="F1" library="rejsacan_synth" deviceset="DS_F1" device="" value="MF-MSMF110/16-2"/>
        <part name="R17" library="rejsacan_synth" deviceset="DS_R17" device="" value="10K"/>
        <part name="C10" library="rejsacan_synth" deviceset="DS_C10" device="" value="22uF"/>
        <part name="C8" library="rejsacan_synth" deviceset="DS_C8" device="" value="22uF"/>
        <part name="C9" library="rejsacan_synth" deviceset="DS_C9" device="" value="22uF"/>
        <part name="D6" library="rejsacan_synth" deviceset="DS_D6" device="" value="DSS34"/>
        <part name="D7" library="rejsacan_synth" deviceset="DS_D7" device="" value="DSS34"/>
        <part name="SD-CARD" library="rejsacan_synth" deviceset="DS_SD-CARD" device="" value="MR01A-01211"/>
        <part name="R4" library="rejsacan_synth" deviceset="DS_R4" device="" value="91K"/>
        <part name="C5" library="rejsacan_synth" deviceset="DS_C5" device="" value="1uF"/>
        <part name="D9" library="rejsacan_synth" deviceset="DS_D9" device="" value="1N4148"/>
        <part name="C6" library="rejsacan_synth" deviceset="DS_C6" device="" value="22uF"/>
        <part name="R6" library="rejsacan_synth" deviceset="DS_R6" device="" value="33K"/>
        <part name="R18" library="rejsacan_synth" deviceset="DS_R18" device="" value="120K"/>
        <part name="R8" library="rejsacan_synth" deviceset="DS_R8" device="" value="10K"/>
        <part name="JUMPER" library="rejsacan_synth" deviceset="DS_JUMPER" device="" value="-"/>
        <part name="U1" library="rejsacan_synth" deviceset="DS_U1" device="" value="ESP32-S3-WROOM-1(N16R8)"/>
        <part name="C13" library="rejsacan_synth" deviceset="DS_C13" device="" value="100nF"/>
        <part name="R9" library="rejsacan_synth" deviceset="DS_R9" device="" value="33K"/>
        <part name="U4" library="rejsacan_synth" deviceset="DS_U4" device="" value="LMR14006XDDCR"/>
        <part name="D4" library="rejsacan_synth" deviceset="DS_D4" device="" value="SMF30A"/>
        <part name="C7" library="rejsacan_synth" deviceset="DS_C7" device="" value="100nF"/>
        <part name="D8" library="rejsacan_synth" deviceset="DS_D8" device="" value="LESD5D5.0CT1G"/>
        <part name="D10" library="rejsacan_synth" deviceset="DS_D10" device="" value="LESD5D5.0CT1G"/>
        <part name="D11" library="rejsacan_synth" deviceset="DS_D11" device="" value="LESD5D5.0CT1G"/>
        <part name="R19" library="rejsacan_synth" deviceset="DS_R19" device="" value="ADJUST"/>
        <part name="USBC" library="rejsacan_synth" deviceset="DS_USBC" device="" value="GT-USB-7010ASV"/>
        <part name="R11" library="rejsacan_synth" deviceset="DS_R11" device="" value="5.1K"/>
        <part name="R12" library="rejsacan_synth" deviceset="DS_R12" device="" value="5.1K"/>
      </parts>
      <sheets>
        <sheet>
          <plain/>
          <instances>
            <instance part="SPI" gate="G$1" x="264.16" y="128.27" rot="R0"/>
            <instance part="R15" gate="G$1" x="44.45" y="105.41" rot="R0"/>
            <instance part="POWER" gate="G$1" x="264.16" y="93.98" rot="R0"/>
            <instance part="GPIO" gate="G$1" x="265.43" y="152.4" rot="R0"/>
            <instance part="I2C" gate="G$1" x="265.43" y="179.07" rot="R0"/>
            <instance part="CAN" gate="G$1" x="264.16" y="109.22" rot="R0"/>
            <instance part="YELLOW" gate="G$1" x="34.29" y="106.68" rot="R0"/>
            <instance part="BLUE" gate="G$1" x="34.29" y="117.602" rot="R180"/>
            <instance part="GREEN" gate="G$1" x="34.29" y="127" rot="R0"/>
            <instance part="R13" gate="G$1" x="44.45" y="125.73" rot="R180"/>
            <instance part="R14" gate="G$1" x="44.45" y="115.57" rot="R0"/>
            <instance part="PROG" gate="G$1" x="105.41" y="133.35" rot="R90"/>
            <instance part="R7" gate="G$1" x="57.15" y="31.75" rot="R270"/>
            <instance part="R5" gate="G$1" x="41.91" y="31.75" rot="R270"/>
            <instance part="Q1" gate="G$1" x="52.07" y="49.53" rot="R0"/>
            <instance part="U3" gate="G$1" x="29.21" y="52.07" rot="R180"/>
            <instance part="L1" gate="G$1" x="137.16" y="31.75" rot="R0"/>
            <instance part="R16" gate="G$1" x="186.69" y="139.7" rot="R270"/>
            <instance part="C12" gate="G$1" x="200.66" y="139.7" rot="R270"/>
            <instance part="C11" gate="G$1" x="156.21" y="138.43" rot="R270"/>
            <instance part="U5" gate="G$1" x="172.72" y="147.32" rot="R0"/>
            <instance part="R10" gate="G$1" x="162.56" y="16.51" rot="R90"/>
            <instance part="D5" gate="G$1" x="120.65" y="20.32" rot="R90"/>
            <instance part="D2" gate="G$1" x="97.79" y="64.77" rot="R0"/>
            <instance part="D3" gate="G$1" x="97.79" y="55.88" rot="R0"/>
            <instance part="D1" gate="G$1" x="57.15" y="53.34" rot="R270"/>
            <instance part="RESET" gate="G$1" x="21.59" y="161.29" rot="R90"/>
            <instance part="R3" gate="G$1" x="180.34" y="168.91" rot="R0"/>
            <instance part="C1" gate="G$1" x="36.83" y="182.88" rot="R90"/>
            <instance part="C4" gate="G$1" x="156.21" y="172.72" rot="R270"/>
            <instance part="C2" gate="G$1" x="43.18" y="182.88" rot="R270"/>
            <instance part="R1" gate="G$1" x="12.7" y="173.99" rot="R270"/>
            <instance part="C3" gate="G$1" x="12.7" y="162.56" rot="R270"/>
            <instance part="U2" gate="G$1" x="180.34" y="181.61" rot="R0"/>
            <instance part="TERMINATION" gate="G$1" x="210.82" y="186.69" rot="R90"/>
            <instance part="R2" gate="G$1" x="210.82" y="180.34" rot="R0"/>
            <instance part="F1" gate="G$1" x="218.44" y="95.25" rot="R0"/>
            <instance part="R17" gate="G$1" x="140.97" y="110.49" rot="R0"/>
            <instance part="C10" gate="G$1" x="152.4" y="16.51" rot="R270"/>
            <instance part="C8" gate="G$1" x="132.08" y="16.51" rot="R270"/>
            <instance part="C9" gate="G$1" x="142.24" y="16.51" rot="R270"/>
            <instance part="D6" gate="G$1" x="233.68" y="95.25" rot="R0"/>
            <instance part="D7" gate="G$1" x="233.68" y="78.74" rot="R0"/>
            <instance part="SD-CARD" gate="G$1" x="163.83" y="95.25" rot="R0"/>
            <instance part="R4" gate="G$1" x="41.91" y="60.96" rot="R270"/>
            <instance part="C5" gate="G$1" x="50.8" y="31.75" rot="R270"/>
            <instance part="D9" gate="G$1" x="62.23" y="44.45" rot="R180"/>
            <instance part="C6" gate="G$1" x="85.09" y="35.56" rot="R270"/>
            <instance part="R6" gate="G$1" x="13.97" y="76.2" rot="R270"/>
            <instance part="R18" gate="G$1" x="13.97" y="87.63" rot="R270"/>
            <instance part="R8" gate="G$1" x="76.2" y="35.56" rot="R270"/>
            <instance part="JUMPER" gate="G$1" x="76.2" y="52.07" rot="R270"/>
            <instance part="U1" gate="G$1" x="78.74" y="162.56" rot="R0"/>
            <instance part="C13" gate="G$1" x="210.82" y="88.9" rot="R270"/>
            <instance part="R9" gate="G$1" x="162.56" y="26.67" rot="R270"/>
            <instance part="U4" gate="G$1" x="102.87" y="41.91" rot="R180"/>
            <instance part="D4" gate="G$1" x="200.66" y="90.17" rot="R90"/>
            <instance part="C7" gate="G$1" x="120.65" y="35.56" rot="R270"/>
            <instance part="D8" gate="G$1" x="196.85" y="52.07" rot="R180"/>
            <instance part="D10" gate="G$1" x="196.85" y="43.18" rot="R180"/>
            <instance part="D11" gate="G$1" x="196.85" y="34.29" rot="R180"/>
            <instance part="R19" gate="G$1" x="33.02" y="31.75" rot="R90"/>
            <instance part="USBC" gate="G$1" x="267.97" y="59.69" rot="R0"/>
            <instance part="R11" gate="G$1" x="242.57" y="53.34" rot="R270"/>
            <instance part="R12" gate="G$1" x="245.11" y="45.72" rot="R270"/>
          </instances>
          <busses/>
          <nets>
            <net name="3V3" class="0">
              <segment>
                <pinref part="I2C" gate="G$1" pin="1"/>
                <wire x1="256.54" y1="182.88" x2="260.35" y2="182.88" width="0.1524" layer="91"/>
                <label x="256.54" y="182.88" size="1.778" layer="95"/>
              </segment>
              <segment>
                <pinref part="C11" gate="G$1" pin="2"/>
                <pinref part="U5" gate="G$1" pin="5"/>
                <wire x1="156.21" y1="143.51" x2="156.21" y2="149.86" width="0.1524" layer="91"/>
                <wire x1="156.21" y1="152.4" x2="156.21" y2="149.86" width="0.1524" layer="91"/>
                <wire x1="156.21" y1="149.86" x2="160.02" y2="149.86" width="0.1524" layer="91"/>
                <junction x="156.21" y="149.86"/>
                <label x="156.21" y="152.4" size="1.778" layer="95"/>
              </segment>
              <segment>
                <pinref part="GREEN" gate="G$1" pin="1"/>
                <wire x1="29.21" y1="125.73" x2="22.86" y2="125.73" width="0.1524" layer="91"/>
                <label x="22.86" y="125.73" size="1.778" layer="95"/>
              </segment>
              <segment>
                <pinref part="R1" gate="G$1" pin="2"/>
                <wire x1="12.7" y1="181.61" x2="12.7" y2="179.07" width="0.1524" layer="91"/>
                <label x="12.7" y="181.61" size="1.778" layer="95"/>
              </segment>
              <segment>
                <pinref part="C4" gate="G$1" pin="2"/>
                <pinref part="U2" gate="G$1" pin="3"/>
                <wire x1="156.21" y1="176.53" x2="156.21" y2="180.34" width="0.1524" layer="91"/>
                <wire x1="156.21" y1="193.04" x2="156.21" y2="180.34" width="0.1524" layer="91"/>
                <wire x1="156.21" y1="180.34" x2="170.18" y2="180.34" width="0.1524" layer="91"/>
                <junction x="156.21" y="180.34"/>
                <label x="156.21" y="193.04" size="1.778" layer="95"/>
              </segment>
              <segment>
                <pinref part="R17" gate="G$1" pin="2"/>
                <pinref part="SD-CARD" gate="G$1" pin="4"/>
                <wire x1="146.05" y1="110.49" x2="148.59" y2="110.49" width="0.1524" layer="91"/>
                <wire x1="148.59" y1="110.49" x2="148.59" y2="102.87" width="0.1524" layer="91"/>
                <wire x1="148.59" y1="102.87" x2="152.4" y2="102.87" width="0.1524" layer="91"/>
                <wire x1="148.59" y1="113.03" x2="148.59" y2="110.49" width="0.1524" layer="91"/>
                <junction x="148.59" y="110.49"/>
                <label x="148.59" y="113.03" size="1.778" layer="95"/>
              </segment>
              <segment>
                <pinref part="L1" gate="G$1" pin="2"/>
                <pinref part="C10" gate="G$1" pin="2"/>
                <pinref part="C8" gate="G$1" pin="2"/>
                <pinref part="C9" gate="G$1" pin="2"/>
                <pinref part="R9" gate="G$1" pin="2"/>
                <wire x1="132.08" y1="21.59" x2="142.24" y2="21.59" width="0.1524" layer="91"/>
                <wire x1="142.24" y1="21.59" x2="152.4" y2="21.59" width="0.1524" layer="91"/>
                <wire x1="152.4" y1="21.59" x2="152.4" y2="31.75" width="0.1524" layer="91"/>
                <wire x1="152.4" y1="31.75" x2="162.56" y2="31.75" width="0.1524" layer="91"/>
                <wire x1="142.24" y1="31.75" x2="152.4" y2="31.75" width="0.1524" layer="91"/>
                <wire x1="162.56" y1="31.75" x2="162.56" y2="48.26" width="0.1524" layer="91"/>
                <junction x="152.4" y="21.59"/>
                <junction x="152.4" y="31.75"/>
                <junction x="142.24" y="21.59"/>
                <junction x="162.56" y="31.75"/>
                <label x="162.56" y="48.26" size="1.778" layer="95"/>
              </segment>
              <segment>
                <pinref part="C1" gate="G$1" pin="1"/>
                <pinref part="C2" gate="G$1" pin="2"/>
                <pinref part="U1" gate="G$1" pin="2"/>
                <wire x1="36.83" y1="186.69" x2="36.83" y2="187.96" width="0.1524" layer="91"/>
                <wire x1="43.18" y1="186.69" x2="43.18" y2="187.96" width="0.1524" layer="91"/>
                <wire x1="36.83" y1="187.96" x2="43.18" y2="187.96" width="0.1524" layer="91"/>
                <wire x1="57.15" y1="171.45" x2="53.34" y2="171.45" width="0.1524" layer="91"/>
                <wire x1="53.34" y1="171.45" x2="53.34" y2="187.96" width="0.1524" layer="91"/>
                <wire x1="53.34" y1="187.96" x2="53.34" y2="189.23" width="0.1524" layer="91"/>
                <wire x1="43.18" y1="187.96" x2="53.34" y2="187.96" width="0.1524" layer="91"/>
                <junction x="53.34" y="187.96"/>
                <junction x="43.18" y="187.96"/>
                <label x="53.34" y="189.23" size="1.778" layer="95"/>
              </segment>
            </net>
            <net name="3V3_SWITCHED" class="0">
              <segment>
                <pinref part="C12" gate="G$1" pin="2"/>
                <pinref part="U5" gate="G$1" pin="1"/>
                <wire x1="200.66" y1="144.78" x2="200.66" y2="149.86" width="0.1524" layer="91"/>
                <wire x1="201.93" y1="149.86" x2="200.66" y2="149.86" width="0.1524" layer="91"/>
                <wire x1="200.66" y1="149.86" x2="185.42" y2="149.86" width="0.1524" layer="91"/>
                <junction x="200.66" y="149.86"/>
                <label x="201.93" y="149.86" size="1.778" layer="95"/>
              </segment>
              <segment>
                <pinref part="GPIO" gate="G$1" pin="1"/>
                <wire x1="260.35" y1="156.21" x2="261.62" y2="156.21" width="0.1524" layer="91"/>
                <label x="260.35" y="156.21" size="1.778" layer="95"/>
              </segment>
            </net>
            <net name="BLUE_LED" class="0">
              <segment>
                <pinref part="U1" gate="G$1" pin="18"/>
                <wire x1="73.66" y1="123.19" x2="73.66" y2="127" width="0.1524" layer="91"/>
                <label x="73.66" y="123.19" size="1.778" layer="95"/>
              </segment>
              <segment>
                <pinref part="BLUE" gate="G$1" pin="1"/>
                <wire x1="29.21" y1="115.57" x2="30.48" y2="115.57" width="0.1524" layer="91"/>
                <label x="29.21" y="115.57" size="1.778" layer="95"/>
              </segment>
            </net>
            <net name="CAN_H" class="0">
              <segment>
                <pinref part="U2" gate="G$1" pin="7"/>
                <pinref part="TERMINATION" gate="G$1" pin="1"/>
                <pinref part="TERMINATION" gate="G$1" pin="2"/>
                <pinref part="R2" gate="G$1" pin="2"/>
                <wire x1="212.09" y1="182.88" x2="209.55" y2="182.88" width="0.1524" layer="91"/>
                <wire x1="209.55" y1="182.88" x2="199.39" y2="182.88" width="0.1524" layer="91"/>
                <wire x1="199.39" y1="182.88" x2="190.5" y2="182.88" width="0.1524" layer="91"/>
                <wire x1="212.09" y1="182.88" x2="215.9" y2="182.88" width="0.1524" layer="91"/>
                <wire x1="215.9" y1="182.88" x2="215.9" y2="180.34" width="0.1524" layer="91"/>
                <junction x="212.09" y="182.88"/>
                <junction x="209.55" y="182.88"/>
                <label x="199.39" y="182.88" size="1.778" layer="95"/>
              </segment>
              <segment>
                <pinref part="CAN" gate="G$1" pin="1"/>
                <wire x1="260.35" y1="110.49" x2="261.62" y2="110.49" width="0.1524" layer="91"/>
                <label x="260.35" y="110.49" size="1.778" layer="95"/>
              </segment>
            </net>
            <net name="CAN_L" class="0">
              <segment>
                <pinref part="U2" gate="G$1" pin="6"/>
                <pinref part="R2" gate="G$1" pin="1"/>
                <wire x1="205.74" y1="180.34" x2="199.39" y2="180.34" width="0.1524" layer="91"/>
                <wire x1="199.39" y1="180.34" x2="190.5" y2="180.34" width="0.1524" layer="91"/>
                <label x="199.39" y="180.34" size="1.778" layer="95"/>
              </segment>
              <segment>
                <pinref part="CAN" gate="G$1" pin="2"/>
                <wire x1="260.35" y1="107.95" x2="261.62" y2="107.95" width="0.1524" layer="91"/>
                <label x="260.35" y="107.95" size="1.778" layer="95"/>
              </segment>
            </net>
            <net name="CAN_RS" class="0">
              <segment>
                <pinref part="R3" gate="G$1" pin="2"/>
                <pinref part="U2" gate="G$1" pin="8"/>
                <wire x1="185.42" y1="168.91" x2="194.31" y2="168.91" width="0.1524" layer="91"/>
                <wire x1="194.31" y1="168.91" x2="194.31" y2="185.42" width="0.1524" layer="91"/>
                <wire x1="194.31" y1="185.42" x2="190.5" y2="185.42" width="0.1524" layer="91"/>
                <wire x1="190.5" y1="163.83" x2="194.31" y2="163.83" width="0.1524" layer="91"/>
                <wire x1="194.31" y1="163.83" x2="194.31" y2="168.91" width="0.1524" layer="91"/>
                <junction x="194.31" y="168.91"/>
                <label x="190.5" y="163.83" size="1.778" layer="95"/>
              </segment>
              <segment>
                <pinref part="U1" gate="G$1" pin="31"/>
                <wire x1="100.33" y1="151.13" x2="104.14" y2="151.13" width="0.1524" layer="91"/>
                <label x="104.14" y="151.13" size="1.778" layer="95"/>
              </segment>
            </net>
            <net name="CAN_RX" class="0">
              <segment>
                <pinref part="U2" gate="G$1" pin="4"/>
                <wire x1="152.4" y1="177.8" x2="170.18" y2="177.8" width="0.1524" layer="91"/>
                <label x="152.4" y="177.8" size="1.778" layer="95"/>
              </segment>
              <segment>
                <pinref part="U1" gate="G$1" pin="21"/>
                <wire x1="81.28" y1="123.19" x2="81.28" y2="127" width="0.1524" layer="91"/>
                <label x="81.28" y="123.19" size="1.778" layer="95"/>
              </segment>
            </net>
            <net name="CAN_TX" class="0">
              <segment>
                <pinref part="U2" gate="G$1" pin="1"/>
                <wire x1="170.18" y1="185.42" x2="152.4" y2="185.42" width="0.1524" layer="91"/>
                <label x="152.4" y="185.42" size="1.778" layer="95"/>
              </segment>
              <segment>
                <pinref part="U1" gate="G$1" pin="22"/>
                <wire x1="83.82" y1="123.19" x2="83.82" y2="127" width="0.1524" layer="91"/>
                <label x="83.82" y="123.19" size="1.778" layer="95"/>
              </segment>
            </net>
            <net name="FORCE_ON" class="0">
              <segment>
                <pinref part="D2" gate="G$1" pin="2"/>
                <wire x1="110.49" y1="64.77" x2="102.87" y2="64.77" width="0.1524" layer="91"/>
                <label x="110.49" y="64.77" size="1.778" layer="95"/>
              </segment>
              <segment>
                <pinref part="U1" gate="G$1" pin="10"/>
                <wire x1="53.34" y1="151.13" x2="57.15" y2="151.13" width="0.1524" layer="91"/>
                <label x="53.34" y="151.13" size="1.778" layer="95"/>
              </segment>
            </net>
            <net name="GND" class="0">
              <segment>
                <pinref part="POWER" gate="G$1" pin="2"/>
                <wire x1="255.27" y1="92.71" x2="260.35" y2="92.71" width="0.1524" layer="91"/>
                <label x="255.27" y="92.71" size="1.778" layer="95"/>
              </segment>
              <segment>
                <pinref part="I2C" gate="G$1" pin="2"/>
                <wire x1="243.84" y1="180.34" x2="260.35" y2="180.34" width="0.1524" layer="91"/>
                <label x="243.84" y="180.34" size="1.778" layer="95"/>
              </segment>
              <segment>
                <pinref part="R15" gate="G$1" pin="2"/>
                <pinref part="R13" gate="G$1" pin="1"/>
                <pinref part="R14" gate="G$1" pin="2"/>
                <wire x1="49.53" y1="105.41" x2="49.53" y2="115.57" width="0.1524" layer="91"/>
                <wire x1="49.53" y1="115.57" x2="49.53" y2="125.73" width="0.1524" layer="91"/>
                <junction x="49.53" y="115.57"/>
                <label x="49.53" y="105.41" size="1.778" layer="95"/>
              </segment>
              <segment>
                <pinref part="R7" gate="G$1" pin="1"/>
                <pinref part="R5" gate="G$1" pin="1"/>
                <pinref part="C5" gate="G$1" pin="1"/>
                <pinref part="R19" gate="G$1" pin="2"/>
                <wire x1="57.15" y1="26.67" x2="57.15" y2="25.4" width="0.1524" layer="91"/>
                <wire x1="57.15" y1="25.4" x2="50.8" y2="25.4" width="0.1524" layer="91"/>
                <wire x1="50.8" y1="26.67" x2="50.8" y2="25.4" width="0.1524" layer="91"/>
                <wire x1="50.8" y1="25.4" x2="41.91" y2="25.4" width="0.1524" layer="91"/>
                <wire x1="41.91" y1="26.67" x2="41.91" y2="25.4" width="0.1524" layer="91"/>
                <wire x1="41.91" y1="25.4" x2="33.02" y2="25.4" width="0.1524" layer="91"/>
                <wire x1="33.02" y1="25.4" x2="33.02" y2="26.67" width="0.1524" layer="91"/>
                <wire x1="57.15" y1="24.13" x2="57.15" y2="25.4" width="0.1524" layer="91"/>
                <junction x="50.8" y="25.4"/>
                <junction x="57.15" y="25.4"/>
                <junction x="41.91" y="25.4"/>
                <label x="57.15" y="24.13" size="1.778" layer="95"/>
              </segment>
              <segment>
                <pinref part="C6" gate="G$1" pin="1"/>
                <pinref part="R8" gate="G$1" pin="1"/>
                <wire x1="76.2" y1="30.48" x2="76.2" y2="26.67" width="0.1524" layer="91"/>
                <wire x1="76.2" y1="26.67" x2="85.09" y2="26.67" width="0.1524" layer="91"/>
                <wire x1="85.09" y1="30.48" x2="85.09" y2="26.67" width="0.1524" layer="91"/>
                <wire x1="85.09" y1="26.67" x2="85.09" y2="24.13" width="0.1524" layer="91"/>
                <junction x="85.09" y="26.67"/>
                <label x="85.09" y="24.13" size="1.778" layer="95"/>
              </segment>
              <segment>
                <pinref part="R16" gate="G$1" pin="1"/>
                <pinref part="C12" gate="G$1" pin="1"/>
                <pinref part="C11" gate="G$1" pin="1"/>
                <pinref part="U5" gate="G$1" pin="2"/>
                <wire x1="186.69" y1="134.62" x2="186.69" y2="133.35" width="0.1524" layer="91"/>
                <wire x1="156.21" y1="133.35" x2="186.69" y2="133.35" width="0.1524" layer="91"/>
                <wire x1="200.66" y1="134.62" x2="200.66" y2="133.35" width="0.1524" layer="91"/>
                <wire x1="200.66" y1="133.35" x2="194.31" y2="133.35" width="0.1524" layer="91"/>
                <wire x1="186.69" y1="133.35" x2="194.31" y2="133.35" width="0.1524" layer="91"/>
                <wire x1="194.31" y1="133.35" x2="194.31" y2="147.32" width="0.1524" layer="91"/>
                <wire x1="194.31" y1="147.32" x2="185.42" y2="147.32" width="0.1524" layer="91"/>
                <junction x="194.31" y="133.35"/>
                <junction x="186.69" y="133.35"/>
                <label x="194.31" y="133.35" size="1.778" layer="95"/>
              </segment>
              <segment>
                <pinref part="R3" gate="G$1" pin="1"/>
                <pinref part="C4" gate="G$1" pin="1"/>
                <pinref part="U2" gate="G$1" pin="2"/>
                <wire x1="156.21" y1="168.91" x2="167.64" y2="168.91" width="0.1524" layer="91"/>
                <wire x1="167.64" y1="168.91" x2="175.26" y2="168.91" width="0.1524" layer="91"/>
                <wire x1="170.18" y1="182.88" x2="167.64" y2="182.88" width="0.1524" layer="91"/>
                <wire x1="167.64" y1="182.88" x2="167.64" y2="168.91" width="0.1524" layer="91"/>
                <wire x1="167.64" y1="168.91" x2="167.64" y2="167.64" width="0.1524" layer="91"/>
                <junction x="167.64" y="168.91"/>
                <label x="167.64" y="168.91" size="1.778" layer="95"/>
              </segment>
              <segment>
                <pinref part="RESET" gate="G$1" pin="2"/>
                <pinref part="C3" gate="G$1" pin="1"/>
                <wire x1="12.7" y1="157.48" x2="12.7" y2="153.67" width="0.1524" layer="91"/>
                <wire x1="12.7" y1="153.67" x2="21.59" y2="153.67" width="0.1524" layer="91"/>
                <label x="12.7" y="153.67" size="1.778" layer="95"/>
              </segment>
              <segment>
                <pinref part="U1" gate="G$1" pin="40"/>
                <pinref part="U1" gate="G$1" pin="41"/>
                <wire x1="100.33" y1="177.8" x2="106.68" y2="177.8" width="0.1524" layer="91"/>
                <wire x1="106.68" y1="177.8" x2="120.65" y2="177.8" width="0.1524" layer="91"/>
                <wire x1="100.33" y1="173.99" x2="106.68" y2="173.99" width="0.1524" layer="91"/>
                <wire x1="106.68" y1="173.99" x2="106.68" y2="177.8" width="0.1524" layer="91"/>
                <junction x="106.68" y="177.8"/>
                <label x="120.65" y="177.8" size="1.778" layer="95"/>
              </segment>
              <segment>
                <pinref part="SD-CARD" gate="G$1" pin="6"/>
                <pinref part="SD-CARD" gate="G$1" pin="10"/>
                <pinref part="SD-CARD" gate="G$1" pin="11"/>
                <pinref part="SD-CARD" gate="G$1" pin="12"/>
                <pinref part="SD-CARD" gate="G$1" pin="13"/>
                <wire x1="152.4" y1="80.01" x2="148.59" y2="80.01" width="0.1524" layer="91"/>
                <wire x1="148.59" y1="80.01" x2="148.59" y2="82.55" width="0.1524" layer="91"/>
                <wire x1="148.59" y1="82.55" x2="148.59" y2="85.09" width="0.1524" layer="91"/>
                <wire x1="148.59" y1="85.09" x2="148.59" y2="87.63" width="0.1524" layer="91"/>
                <wire x1="148.59" y1="87.63" x2="148.59" y2="97.79" width="0.1524" layer="91"/>
                <wire x1="148.59" y1="97.79" x2="152.4" y2="97.79" width="0.1524" layer="91"/>
                <wire x1="152.4" y1="87.63" x2="148.59" y2="87.63" width="0.1524" layer="91"/>
                <wire x1="152.4" y1="85.09" x2="148.59" y2="85.09" width="0.1524" layer="91"/>
                <wire x1="152.4" y1="82.55" x2="148.59" y2="82.55" width="0.1524" layer="91"/>
                <junction x="148.59" y="82.55"/>
                <junction x="148.59" y="85.09"/>
                <junction x="148.59" y="87.63"/>
                <label x="148.59" y="80.01" size="1.778" layer="95"/>
              </segment>
              <segment>
                <pinref part="C1" gate="G$1" pin="2"/>
                <pinref part="C2" gate="G$1" pin="1"/>
                <pinref part="U1" gate="G$1" pin="1"/>
                <pinref part="U1" gate="G$1" pin="4"/>
                <pinref part="U1" gate="G$1" pin="5"/>
                <wire x1="57.15" y1="173.99" x2="49.53" y2="173.99" width="0.1524" layer="91"/>
                <wire x1="49.53" y1="173.99" x2="49.53" y2="179.07" width="0.1524" layer="91"/>
                <wire x1="43.18" y1="179.07" x2="36.83" y2="179.07" width="0.1524" layer="91"/>
                <wire x1="49.53" y1="179.07" x2="43.18" y2="179.07" width="0.1524" layer="91"/>
                <wire x1="57.15" y1="163.83" x2="49.53" y2="163.83" width="0.1524" layer="91"/>
                <wire x1="49.53" y1="163.83" x2="49.53" y2="166.37" width="0.1524" layer="91"/>
                <wire x1="49.53" y1="166.37" x2="49.53" y2="173.99" width="0.1524" layer="91"/>
                <wire x1="57.15" y1="166.37" x2="49.53" y2="166.37" width="0.1524" layer="91"/>
                <junction x="49.53" y="173.99"/>
                <junction x="49.53" y="166.37"/>
                <junction x="43.18" y="179.07"/>
                <label x="43.18" y="179.07" size="1.778" layer="95"/>
              </segment>
              <segment>
                <pinref part="C13" gate="G$1" pin="1"/>
                <pinref part="D4" gate="G$1" pin="2"/>
                <wire x1="210.82" y1="83.82" x2="210.82" y2="82.55" width="0.1524" layer="91"/>
                <wire x1="210.82" y1="82.55" x2="200.66" y2="82.55" width="0.1524" layer="91"/>
                <wire x1="200.66" y1="82.55" x2="200.66" y2="85.09" width="0.1524" layer="91"/>
                <label x="210.82" y="82.55" size="1.778" layer="95"/>
              </segment>
              <segment>
                <pinref part="R10" gate="G$1" pin="2"/>
                <pinref part="D5" gate="G$1" pin="2"/>
                <pinref part="C10" gate="G$1" pin="1"/>
                <pinref part="C8" gate="G$1" pin="1"/>
                <pinref part="C9" gate="G$1" pin="1"/>
                <pinref part="U4" gate="G$1" pin="2"/>
                <wire x1="162.56" y1="11.43" x2="152.4" y2="11.43" width="0.1524" layer="91"/>
                <wire x1="152.4" y1="11.43" x2="142.24" y2="11.43" width="0.1524" layer="91"/>
                <wire x1="142.24" y1="11.43" x2="132.08" y2="11.43" width="0.1524" layer="91"/>
                <wire x1="120.65" y1="15.24" x2="120.65" y2="11.43" width="0.1524" layer="91"/>
                <wire x1="132.08" y1="11.43" x2="120.65" y2="11.43" width="0.1524" layer="91"/>
                <wire x1="120.65" y1="11.43" x2="116.84" y2="11.43" width="0.1524" layer="91"/>
                <wire x1="116.84" y1="11.43" x2="116.84" y2="41.91" width="0.1524" layer="91"/>
                <wire x1="116.84" y1="41.91" x2="114.3" y2="41.91" width="0.1524" layer="91"/>
                <junction x="142.24" y="11.43"/>
                <junction x="132.08" y="11.43"/>
                <junction x="120.65" y="11.43"/>
                <junction x="152.4" y="11.43"/>
                <label x="120.65" y="11.43" size="1.778" layer="95"/>
              </segment>
              <segment>
                <pinref part="D8" gate="G$1" pin="2"/>
                <pinref part="D10" gate="G$1" pin="2"/>
                <pinref part="D11" gate="G$1" pin="2"/>
                <wire x1="191.77" y1="43.18" x2="186.69" y2="43.18" width="0.1524" layer="91"/>
                <wire x1="186.69" y1="43.18" x2="186.69" y2="34.29" width="0.1524" layer="91"/>
                <wire x1="186.69" y1="34.29" x2="191.77" y2="34.29" width="0.1524" layer="91"/>
                <wire x1="191.77" y1="52.07" x2="186.69" y2="52.07" width="0.1524" layer="91"/>
                <wire x1="186.69" y1="52.07" x2="186.69" y2="43.18" width="0.1524" layer="91"/>
                <junction x="186.69" y="43.18"/>
                <label x="186.69" y="34.29" size="1.778" layer="95"/>
              </segment>
              <segment>
                <pinref part="U3" gate="G$1" pin="2"/>
                <wire x1="31.75" y1="52.07" x2="33.02" y2="52.07" width="0.1524" layer="91"/>
                <wire x1="33.02" y1="52.07" x2="33.02" y2="48.26" width="0.1524" layer="91"/>
                <label x="33.02" y="48.26" size="1.778" layer="95"/>
              </segment>
              <segment>
                <pinref part="USBC" gate="G$1" pin="4"/>
                <pinref part="USBC" gate="G$1" pin="3"/>
                <pinref part="USBC" gate="G$1" pin="2"/>
                <pinref part="USBC" gate="G$1" pin="1"/>
                <pinref part="USBC" gate="G$1" pin="B1A12"/>
                <pinref part="USBC" gate="G$1" pin="A1B12"/>
                <pinref part="R11" gate="G$1" pin="1"/>
                <pinref part="R12" gate="G$1" pin="1"/>
                <wire x1="255.27" y1="74.93" x2="248.92" y2="74.93" width="0.1524" layer="91"/>
                <wire x1="248.92" y1="74.93" x2="248.92" y2="78.74" width="0.1524" layer="91"/>
                <wire x1="248.92" y1="78.74" x2="278.13" y2="78.74" width="0.1524" layer="91"/>
                <wire x1="278.13" y1="78.74" x2="278.13" y2="74.93" width="0.1524" layer="91"/>
                <wire x1="278.13" y1="74.93" x2="278.13" y2="72.39" width="0.1524" layer="91"/>
                <wire x1="278.13" y1="72.39" x2="278.13" y2="49.53" width="0.1524" layer="91"/>
                <wire x1="278.13" y1="49.53" x2="278.13" y2="46.99" width="0.1524" layer="91"/>
                <wire x1="278.13" y1="46.99" x2="278.13" y2="39.37" width="0.1524" layer="91"/>
                <wire x1="255.27" y1="46.99" x2="248.92" y2="46.99" width="0.1524" layer="91"/>
                <wire x1="248.92" y1="46.99" x2="248.92" y2="39.37" width="0.1524" layer="91"/>
                <wire x1="248.92" y1="39.37" x2="278.13" y2="39.37" width="0.1524" layer="91"/>
                <wire x1="242.57" y1="48.26" x2="242.57" y2="39.37" width="0.1524" layer="91"/>
                <wire x1="242.57" y1="39.37" x2="245.11" y2="39.37" width="0.1524" layer="91"/>
                <wire x1="245.11" y1="39.37" x2="248.92" y2="39.37" width="0.1524" layer="91"/>
                <wire x1="245.11" y1="40.64" x2="245.11" y2="39.37" width="0.1524" layer="91"/>
                <junction x="248.92" y="39.37"/>
                <junction x="278.13" y="72.39"/>
                <junction x="278.13" y="49.53"/>
                <junction x="245.11" y="39.37"/>
                <junction x="278.13" y="46.99"/>
                <junction x="278.13" y="74.93"/>
                <label x="278.13" y="39.37" size="1.778" layer="95"/>
              </segment>
              <segment>
                <pinref part="PROG" gate="G$1" pin="2"/>
                <wire x1="105.41" y1="125.73" x2="106.68" y2="125.73" width="0.1524" layer="91"/>
                <label x="105.41" y="125.73" size="1.778" layer="95"/>
              </segment>
              <segment>
                <pinref part="R6" gate="G$1" pin="1"/>
                <wire x1="13.97" y1="71.12" x2="15.24" y2="71.12" width="0.1524" layer="91"/>
                <label x="13.97" y="71.12" size="1.778" layer="95"/>
              </segment>
            </net>
            <net name="GPIO12" class="0">
              <segment>
                <pinref part="U1" gate="G$1" pin="20"/>
                <wire x1="78.74" y1="123.19" x2="78.74" y2="127" width="0.1524" layer="91"/>
                <label x="78.74" y="123.19" size="1.778" layer="95"/>
              </segment>
              <segment>
                <pinref part="GPIO" gate="G$1" pin="4"/>
                <wire x1="260.35" y1="148.59" x2="261.62" y2="148.59" width="0.1524" layer="91"/>
                <label x="260.35" y="148.59" size="1.778" layer="95"/>
              </segment>
            </net>
            <net name="GPIO15" class="0">
              <segment>
                <pinref part="U1" gate="G$1" pin="8"/>
                <wire x1="46.99" y1="156.21" x2="57.15" y2="156.21" width="0.1524" layer="91"/>
                <label x="46.99" y="156.21" size="1.778" layer="95"/>
              </segment>
            </net>
            <net name="GPIO16" class="0">
              <segment>
                <pinref part="U1" gate="G$1" pin="9"/>
                <wire x1="46.99" y1="153.67" x2="57.15" y2="153.67" width="0.1524" layer="91"/>
                <label x="46.99" y="153.67" size="1.778" layer="95"/>
              </segment>
            </net>
            <net name="GPIO47" class="0">
              <segment>
                <pinref part="U1" gate="G$1" pin="24"/>
                <wire x1="88.9" y1="123.19" x2="88.9" y2="127" width="0.1524" layer="91"/>
                <label x="88.9" y="123.19" size="1.778" layer="95"/>
              </segment>
              <segment>
                <pinref part="GPIO" gate="G$1" pin="2"/>
                <wire x1="260.35" y1="153.67" x2="261.62" y2="153.67" width="0.1524" layer="91"/>
                <label x="260.35" y="153.67" size="1.778" layer="95"/>
              </segment>
            </net>
            <net name="GPIO48" class="0">
              <segment>
                <pinref part="U1" gate="G$1" pin="25"/>
                <wire x1="91.44" y1="123.19" x2="91.44" y2="127" width="0.1524" layer="91"/>
                <label x="91.44" y="123.19" size="1.778" layer="95"/>
              </segment>
              <segment>
                <pinref part="GPIO" gate="G$1" pin="3"/>
                <wire x1="260.35" y1="151.13" x2="261.62" y2="151.13" width="0.1524" layer="91"/>
                <label x="260.35" y="151.13" size="1.778" layer="95"/>
              </segment>
            </net>
            <net name="GPIO6" class="0">
              <segment>
                <pinref part="U1" gate="G$1" pin="6"/>
                <wire x1="46.99" y1="161.29" x2="57.15" y2="161.29" width="0.1524" layer="91"/>
                <label x="46.99" y="161.29" size="1.778" layer="95"/>
              </segment>
            </net>
            <net name="GPIO7" class="0">
              <segment>
                <pinref part="U1" gate="G$1" pin="7"/>
                <wire x1="46.99" y1="158.75" x2="57.15" y2="158.75" width="0.1524" layer="91"/>
                <label x="46.99" y="158.75" size="1.778" layer="95"/>
              </segment>
            </net>
            <net name="HI_DRIVER" class="0">
              <segment>
                <pinref part="U5" gate="G$1" pin="4"/>
                <wire x1="160.02" y1="144.78" x2="152.4" y2="144.78" width="0.1524" layer="91"/>
                <label x="152.4" y="144.78" size="1.778" layer="95"/>
              </segment>
              <segment>
                <pinref part="U1" gate="G$1" pin="23"/>
                <wire x1="86.36" y1="123.19" x2="86.36" y2="127" width="0.1524" layer="91"/>
                <label x="86.36" y="123.19" size="1.778" layer="95"/>
              </segment>
            </net>
            <net name="JTAG_ENABLE" class="0">
              <segment>
                <pinref part="U1" gate="G$1" pin="15"/>
                <wire x1="66.04" y1="123.19" x2="66.04" y2="127" width="0.1524" layer="91"/>
                <label x="66.04" y="123.19" size="1.778" layer="95"/>
              </segment>
            </net>
            <net name="MTCK" class="0">
              <segment>
                <pinref part="SD-CARD" gate="G$1" pin="5"/>
                <wire x1="130.81" y1="100.33" x2="152.4" y2="100.33" width="0.1524" layer="91"/>
                <label x="130.81" y="100.33" size="1.778" layer="95"/>
              </segment>
              <segment>
                <pinref part="U1" gate="G$1" pin="32"/>
                <wire x1="100.33" y1="153.67" x2="104.14" y2="153.67" width="0.1524" layer="91"/>
                <label x="104.14" y="153.67" size="1.778" layer="95"/>
              </segment>
              <segment>
                <pinref part="SPI" gate="G$1" pin="2"/>
                <wire x1="260.35" y1="128.27" x2="261.62" y2="128.27" width="0.1524" layer="91"/>
                <label x="260.35" y="128.27" size="1.778" layer="95"/>
              </segment>
            </net>
            <net name="MTDI" class="0">
              <segment>
                <pinref part="R17" gate="G$1" pin="1"/>
                <pinref part="SD-CARD" gate="G$1" pin="7"/>
                <wire x1="130.81" y1="95.25" x2="135.89" y2="95.25" width="0.1524" layer="91"/>
                <wire x1="135.89" y1="95.25" x2="152.4" y2="95.25" width="0.1524" layer="91"/>
                <wire x1="135.89" y1="110.49" x2="135.89" y2="95.25" width="0.1524" layer="91"/>
                <junction x="135.89" y="95.25"/>
                <label x="130.81" y="95.25" size="1.778" layer="95"/>
              </segment>
              <segment>
                <pinref part="U1" gate="G$1" pin="34"/>
                <wire x1="100.33" y1="158.75" x2="104.14" y2="158.75" width="0.1524" layer="91"/>
                <label x="104.14" y="158.75" size="1.778" layer="95"/>
              </segment>
              <segment>
                <pinref part="SPI" gate="G$1" pin="3"/>
                <wire x1="260.35" y1="125.73" x2="261.62" y2="125.73" width="0.1524" layer="91"/>
                <label x="260.35" y="125.73" size="1.778" layer="95"/>
              </segment>
            </net>
            <net name="MTDO" class="0">
              <segment>
                <pinref part="SD-CARD" gate="G$1" pin="3"/>
                <wire x1="130.81" y1="105.41" x2="152.4" y2="105.41" width="0.1524" layer="91"/>
                <label x="130.81" y="105.41" size="1.778" layer="95"/>
              </segment>
              <segment>
                <pinref part="U1" gate="G$1" pin="33"/>
                <wire x1="100.33" y1="156.21" x2="104.14" y2="156.21" width="0.1524" layer="91"/>
                <label x="104.14" y="156.21" size="1.778" layer="95"/>
              </segment>
              <segment>
                <pinref part="SPI" gate="G$1" pin="1"/>
                <wire x1="260.35" y1="130.81" x2="261.62" y2="130.81" width="0.1524" layer="91"/>
                <label x="260.35" y="130.81" size="1.778" layer="95"/>
              </segment>
            </net>
            <net name="MTMS" class="0">
              <segment>
                <pinref part="U1" gate="G$1" pin="35"/>
                <wire x1="111.76" y1="161.29" x2="100.33" y2="161.29" width="0.1524" layer="91"/>
                <label x="111.76" y="161.29" size="1.778" layer="95"/>
              </segment>
            </net>
            <net name="N$1" class="0">
              <segment>
                <pinref part="R15" gate="G$1" pin="1"/>
                <pinref part="YELLOW" gate="G$1" pin="2"/>
                <junction x="39.37" y="105.41"/>
              </segment>
            </net>
            <net name="N$10" class="0">
              <segment>
                <pinref part="R10" gate="G$1" pin="1"/>
                <pinref part="R9" gate="G$1" pin="1"/>
                <pinref part="U4" gate="G$1" pin="3"/>
                <wire x1="114.3" y1="44.45" x2="157.48" y2="44.45" width="0.1524" layer="91"/>
                <wire x1="157.48" y1="44.45" x2="157.48" y2="21.59" width="0.1524" layer="91"/>
                <wire x1="157.48" y1="21.59" x2="162.56" y2="21.59" width="0.1524" layer="91"/>
                <junction x="162.56" y="21.59"/>
              </segment>
            </net>
            <net name="N$11" class="0">
              <segment>
                <pinref part="D2" gate="G$1" pin="1"/>
                <pinref part="D3" gate="G$1" pin="1"/>
                <pinref part="D9" gate="G$1" pin="1"/>
                <pinref part="R8" gate="G$1" pin="2"/>
                <pinref part="JUMPER" gate="G$1" pin="1"/>
                <pinref part="U4" gate="G$1" pin="4"/>
                <wire x1="76.2" y1="40.64" x2="76.2" y2="44.45" width="0.1524" layer="91"/>
                <wire x1="76.2" y1="44.45" x2="88.9" y2="44.45" width="0.1524" layer="91"/>
                <wire x1="88.9" y1="44.45" x2="91.44" y2="44.45" width="0.1524" layer="91"/>
                <wire x1="92.71" y1="64.77" x2="88.9" y2="64.77" width="0.1524" layer="91"/>
                <wire x1="88.9" y1="64.77" x2="88.9" y2="55.88" width="0.1524" layer="91"/>
                <wire x1="88.9" y1="55.88" x2="88.9" y2="44.45" width="0.1524" layer="91"/>
                <wire x1="92.71" y1="55.88" x2="88.9" y2="55.88" width="0.1524" layer="91"/>
                <wire x1="76.2" y1="44.45" x2="67.31" y2="44.45" width="0.1524" layer="91"/>
                <wire x1="76.2" y1="46.99" x2="76.2" y2="44.45" width="0.1524" layer="91"/>
                <junction x="88.9" y="44.45"/>
                <junction x="76.2" y="44.45"/>
                <junction x="88.9" y="55.88"/>
              </segment>
            </net>
            <net name="N$12" class="0">
              <segment>
                <pinref part="RESET" gate="G$1" pin="1"/>
                <pinref part="R1" gate="G$1" pin="1"/>
                <pinref part="C3" gate="G$1" pin="2"/>
                <pinref part="U1" gate="G$1" pin="3"/>
                <wire x1="57.15" y1="168.91" x2="21.59" y2="168.91" width="0.1524" layer="91"/>
                <wire x1="12.7" y1="167.64" x2="12.7" y2="168.91" width="0.1524" layer="91"/>
                <wire x1="21.59" y1="168.91" x2="12.7" y2="168.91" width="0.1524" layer="91"/>
                <junction x="12.7" y="168.91"/>
                <junction x="21.59" y="168.91"/>
              </segment>
            </net>
            <net name="N$13" class="0">
              <segment>
                <pinref part="U2" gate="G$1" pin="5"/>
                <wire x1="190.5" y1="177.8" x2="191.77" y2="177.8" width="0.1524" layer="91"/>
              </segment>
            </net>
            <net name="N$14" class="0">
              <segment>
                <pinref part="F1" gate="G$1" pin="2"/>
                <pinref part="D6" gate="G$1" pin="1"/>
                <pinref part="D7" gate="G$1" pin="1"/>
                <wire x1="223.52" y1="95.25" x2="227.33" y2="95.25" width="0.1524" layer="91"/>
                <wire x1="227.33" y1="95.25" x2="228.6" y2="95.25" width="0.1524" layer="91"/>
                <wire x1="228.6" y1="78.74" x2="227.33" y2="78.74" width="0.1524" layer="91"/>
                <wire x1="227.33" y1="78.74" x2="227.33" y2="95.25" width="0.1524" layer="91"/>
                <junction x="227.33" y="95.25"/>
              </segment>
            </net>
            <net name="N$15" class="0">
              <segment>
                <pinref part="SD-CARD" gate="G$1" pin="1"/>
                <wire x1="152.4" y1="110.49" x2="153.67" y2="110.49" width="0.1524" layer="91"/>
              </segment>
            </net>
            <net name="N$16" class="0">
              <segment>
                <pinref part="SD-CARD" gate="G$1" pin="8"/>
                <wire x1="152.4" y1="92.71" x2="153.67" y2="92.71" width="0.1524" layer="91"/>
              </segment>
            </net>
            <net name="N$17" class="0">
              <segment>
                <pinref part="SD-CARD" gate="G$1" pin="9"/>
                <wire x1="152.4" y1="90.17" x2="153.67" y2="90.17" width="0.1524" layer="91"/>
              </segment>
            </net>
            <net name="N$18" class="0">
              <segment>
                <pinref part="U1" gate="G$1" pin="11"/>
                <wire x1="57.15" y1="148.59" x2="58.42" y2="148.59" width="0.1524" layer="91"/>
              </segment>
            </net>
            <net name="N$19" class="0">
              <segment>
                <pinref part="U1" gate="G$1" pin="16"/>
                <wire x1="68.58" y1="127" x2="69.85" y2="127" width="0.1524" layer="91"/>
              </segment>
            </net>
            <net name="N$2" class="0">
              <segment>
                <pinref part="POWER" gate="G$1" pin="1"/>
                <pinref part="D6" gate="G$1" pin="2"/>
                <wire x1="260.35" y1="95.25" x2="238.76" y2="95.25" width="0.1524" layer="91"/>
              </segment>
            </net>
            <net name="N$20" class="0">
              <segment>
                <pinref part="U1" gate="G$1" pin="28"/>
                <wire x1="100.33" y1="143.51" x2="101.6" y2="143.51" width="0.1524" layer="91"/>
              </segment>
            </net>
            <net name="N$21" class="0">
              <segment>
                <pinref part="U1" gate="G$1" pin="29"/>
                <wire x1="100.33" y1="146.05" x2="101.6" y2="146.05" width="0.1524" layer="91"/>
              </segment>
            </net>
            <net name="N$22" class="0">
              <segment>
                <pinref part="U1" gate="G$1" pin="30"/>
                <wire x1="100.33" y1="148.59" x2="101.6" y2="148.59" width="0.1524" layer="91"/>
              </segment>
            </net>
            <net name="N$23" class="0">
              <segment>
                <pinref part="U4" gate="G$1" pin="1"/>
                <pinref part="C7" gate="G$1" pin="2"/>
                <wire x1="114.3" y1="39.37" x2="120.65" y2="39.37" width="0.1524" layer="91"/>
              </segment>
            </net>
            <net name="N$24" class="0">
              <segment>
                <pinref part="USBC" gate="G$1" pin="B5"/>
                <pinref part="R12" gate="G$1" pin="2"/>
                <wire x1="255.27" y1="52.07" x2="245.11" y2="52.07" width="0.1524" layer="91"/>
                <wire x1="245.11" y1="52.07" x2="245.11" y2="50.8" width="0.1524" layer="91"/>
              </segment>
            </net>
            <net name="N$25" class="0">
              <segment>
                <pinref part="USBC" gate="G$1" pin="A8"/>
                <wire x1="255.27" y1="54.61" x2="256.54" y2="54.61" width="0.1524" layer="91"/>
              </segment>
            </net>
            <net name="N$26" class="0">
              <segment>
                <pinref part="USBC" gate="G$1" pin="A5"/>
                <pinref part="R11" gate="G$1" pin="2"/>
                <wire x1="255.27" y1="67.31" x2="242.57" y2="67.31" width="0.1524" layer="91"/>
                <wire x1="242.57" y1="67.31" x2="242.57" y2="58.42" width="0.1524" layer="91"/>
              </segment>
            </net>
            <net name="N$27" class="0">
              <segment>
                <pinref part="USBC" gate="G$1" pin="B8"/>
                <wire x1="255.27" y1="69.85" x2="256.54" y2="69.85" width="0.1524" layer="91"/>
              </segment>
            </net>
            <net name="N$3" class="0">
              <segment>
                <pinref part="BLUE" gate="G$1" pin="2"/>
                <pinref part="R14" gate="G$1" pin="1"/>
                <junction x="39.37" y="115.57"/>
              </segment>
            </net>
            <net name="N$4" class="0">
              <segment>
                <pinref part="GREEN" gate="G$1" pin="2"/>
                <pinref part="R13" gate="G$1" pin="2"/>
                <junction x="39.37" y="125.73"/>
              </segment>
            </net>
            <net name="N$5" class="0">
              <segment>
                <pinref part="R7" gate="G$1" pin="2"/>
                <pinref part="Q1" gate="G$1" pin="2"/>
                <pinref part="D1" gate="G$1" pin="1"/>
                <pinref part="D9" gate="G$1" pin="2"/>
                <wire x1="52.07" y1="44.45" x2="57.15" y2="44.45" width="0.1524" layer="91"/>
                <wire x1="57.15" y1="44.45" x2="57.15" y2="48.26" width="0.1524" layer="91"/>
                <wire x1="57.15" y1="44.45" x2="57.15" y2="36.83" width="0.1524" layer="91"/>
                <junction x="57.15" y="44.45"/>
              </segment>
            </net>
            <net name="N$6" class="0">
              <segment>
                <pinref part="R5" gate="G$1" pin="2"/>
                <pinref part="U3" gate="G$1" pin="3"/>
                <pinref part="R4" gate="G$1" pin="1"/>
                <pinref part="C5" gate="G$1" pin="2"/>
                <pinref part="R19" gate="G$1" pin="1"/>
                <wire x1="50.8" y1="36.83" x2="50.8" y2="38.1" width="0.1524" layer="91"/>
                <wire x1="50.8" y1="38.1" x2="41.91" y2="38.1" width="0.1524" layer="91"/>
                <wire x1="41.91" y1="38.1" x2="33.02" y2="38.1" width="0.1524" layer="91"/>
                <wire x1="33.02" y1="38.1" x2="33.02" y2="36.83" width="0.1524" layer="91"/>
                <wire x1="41.91" y1="36.83" x2="41.91" y2="38.1" width="0.1524" layer="91"/>
                <wire x1="31.75" y1="54.61" x2="41.91" y2="54.61" width="0.1524" layer="91"/>
                <wire x1="41.91" y1="54.61" x2="41.91" y2="55.88" width="0.1524" layer="91"/>
                <wire x1="41.91" y1="38.1" x2="41.91" y2="54.61" width="0.1524" layer="91"/>
                <junction x="41.91" y="38.1"/>
                <junction x="41.91" y="54.61"/>
              </segment>
            </net>
            <net name="N$7" class="0">
              <segment>
                <pinref part="Q1" gate="G$1" pin="1"/>
                <pinref part="U3" gate="G$1" pin="1"/>
                <wire x1="31.75" y1="49.53" x2="46.99" y2="49.53" width="0.1524" layer="91"/>
              </segment>
            </net>
            <net name="N$8" class="0">
              <segment>
                <pinref part="L1" gate="G$1" pin="1"/>
                <pinref part="D5" gate="G$1" pin="1"/>
                <pinref part="U4" gate="G$1" pin="6"/>
                <pinref part="C7" gate="G$1" pin="1"/>
                <wire x1="132.08" y1="31.75" x2="120.65" y2="31.75" width="0.1524" layer="91"/>
                <wire x1="120.65" y1="31.75" x2="91.44" y2="31.75" width="0.1524" layer="91"/>
                <wire x1="91.44" y1="31.75" x2="91.44" y2="39.37" width="0.1524" layer="91"/>
                <wire x1="120.65" y1="25.4" x2="120.65" y2="31.75" width="0.1524" layer="91"/>
                <junction x="120.65" y="31.75"/>
              </segment>
            </net>
            <net name="N$9" class="0">
              <segment>
                <pinref part="R16" gate="G$1" pin="2"/>
                <pinref part="U5" gate="G$1" pin="3"/>
                <wire x1="186.69" y1="144.78" x2="185.42" y2="144.78" width="0.1524" layer="91"/>
              </segment>
            </net>
            <net name="PROG" class="0">
              <segment>
                <pinref part="PROG" gate="G$1" pin="1"/>
                <pinref part="U1" gate="G$1" pin="27"/>
                <wire x1="105.41" y1="140.97" x2="100.33" y2="140.97" width="0.1524" layer="91"/>
                <wire x1="110.49" y1="140.97" x2="105.41" y2="140.97" width="0.1524" layer="91"/>
                <junction x="105.41" y="140.97"/>
                <label x="110.49" y="140.97" size="1.778" layer="95"/>
              </segment>
            </net>
            <net name="RXD" class="0">
              <segment>
                <pinref part="U1" gate="G$1" pin="36"/>
                <wire x1="111.76" y1="163.83" x2="100.33" y2="163.83" width="0.1524" layer="91"/>
                <label x="111.76" y="163.83" size="1.778" layer="95"/>
              </segment>
            </net>
            <net name="SCL" class="0">
              <segment>
                <pinref part="U1" gate="G$1" pin="38"/>
                <wire x1="100.33" y1="168.91" x2="104.14" y2="168.91" width="0.1524" layer="91"/>
                <label x="104.14" y="168.91" size="1.778" layer="95"/>
              </segment>
              <segment>
                <pinref part="I2C" gate="G$1" pin="3"/>
                <wire x1="260.35" y1="177.8" x2="261.62" y2="177.8" width="0.1524" layer="91"/>
                <label x="260.35" y="177.8" size="1.778" layer="95"/>
              </segment>
            </net>
            <net name="SDA" class="0">
              <segment>
                <pinref part="U1" gate="G$1" pin="39"/>
                <wire x1="100.33" y1="171.45" x2="104.14" y2="171.45" width="0.1524" layer="91"/>
                <label x="104.14" y="171.45" size="1.778" layer="95"/>
              </segment>
              <segment>
                <pinref part="I2C" gate="G$1" pin="4"/>
                <wire x1="260.35" y1="175.26" x2="261.62" y2="175.26" width="0.1524" layer="91"/>
                <label x="260.35" y="175.26" size="1.778" layer="95"/>
              </segment>
            </net>
            <net name="SD_CARD" class="0">
              <segment>
                <pinref part="SD-CARD" gate="G$1" pin="2"/>
                <wire x1="152.4" y1="107.95" x2="130.81" y2="107.95" width="0.1524" layer="91"/>
                <label x="130.81" y="107.95" size="1.778" layer="95"/>
              </segment>
              <segment>
                <pinref part="U1" gate="G$1" pin="26"/>
                <wire x1="93.98" y1="123.19" x2="93.98" y2="127" width="0.1524" layer="91"/>
                <label x="93.98" y="123.19" size="1.778" layer="95"/>
              </segment>
            </net>
            <net name="SENSE_V_ANA" class="0">
              <segment>
                <pinref part="R6" gate="G$1" pin="2"/>
                <pinref part="R18" gate="G$1" pin="1"/>
                <wire x1="13.97" y1="82.55" x2="13.97" y2="81.28" width="0.1524" layer="91"/>
                <wire x1="13.97" y1="81.28" x2="19.05" y2="81.28" width="0.1524" layer="91"/>
                <junction x="13.97" y="81.28"/>
                <label x="19.05" y="81.28" size="1.778" layer="95"/>
              </segment>
              <segment>
                <pinref part="U1" gate="G$1" pin="17"/>
                <wire x1="71.12" y1="123.19" x2="71.12" y2="127" width="0.1524" layer="91"/>
                <label x="71.12" y="123.19" size="1.778" layer="95"/>
              </segment>
            </net>
            <net name="SENSE_V_DIG" class="0">
              <segment>
                <pinref part="D1" gate="G$1" pin="2"/>
                <wire x1="57.15" y1="67.31" x2="57.15" y2="58.42" width="0.1524" layer="91"/>
                <label x="57.15" y="67.31" size="1.778" layer="95"/>
              </segment>
              <segment>
                <pinref part="U1" gate="G$1" pin="12"/>
                <wire x1="53.34" y1="146.05" x2="57.15" y2="146.05" width="0.1524" layer="91"/>
                <label x="53.34" y="146.05" size="1.778" layer="95"/>
              </segment>
            </net>
            <net name="TXD" class="0">
              <segment>
                <pinref part="U1" gate="G$1" pin="37"/>
                <wire x1="111.76" y1="166.37" x2="100.33" y2="166.37" width="0.1524" layer="91"/>
                <label x="111.76" y="166.37" size="1.778" layer="95"/>
              </segment>
            </net>
            <net name="USB5V" class="0">
              <segment>
                <pinref part="D7" gate="G$1" pin="2"/>
                <pinref part="D11" gate="G$1" pin="1"/>
                <pinref part="USBC" gate="G$1" pin="B4A9"/>
                <pinref part="USBC" gate="G$1" pin="A4B9"/>
                <wire x1="186.69" y1="67.31" x2="223.52" y2="67.31" width="0.1524" layer="91"/>
                <wire x1="223.52" y1="67.31" x2="238.76" y2="67.31" width="0.1524" layer="91"/>
                <wire x1="238.76" y1="78.74" x2="238.76" y2="72.39" width="0.1524" layer="91"/>
                <wire x1="238.76" y1="72.39" x2="238.76" y2="67.31" width="0.1524" layer="91"/>
                <wire x1="201.93" y1="34.29" x2="223.52" y2="34.29" width="0.1524" layer="91"/>
                <wire x1="223.52" y1="34.29" x2="223.52" y2="67.31" width="0.1524" layer="91"/>
                <wire x1="255.27" y1="49.53" x2="248.92" y2="49.53" width="0.1524" layer="91"/>
                <wire x1="248.92" y1="49.53" x2="248.92" y2="72.39" width="0.1524" layer="91"/>
                <wire x1="248.92" y1="72.39" x2="255.27" y2="72.39" width="0.1524" layer="91"/>
                <wire x1="238.76" y1="72.39" x2="248.92" y2="72.39" width="0.1524" layer="91"/>
                <junction x="248.92" y="72.39"/>
                <junction x="223.52" y="67.31"/>
                <junction x="238.76" y="72.39"/>
                <label x="186.69" y="67.31" size="1.778" layer="95"/>
              </segment>
              <segment>
                <pinref part="D3" gate="G$1" pin="2"/>
                <wire x1="102.87" y1="55.88" x2="110.49" y2="55.88" width="0.1524" layer="91"/>
                <label x="110.49" y="55.88" size="1.778" layer="95"/>
              </segment>
            </net>
            <net name="USB_D+" class="0">
              <segment>
                <pinref part="D10" gate="G$1" pin="1"/>
                <pinref part="USBC" gate="G$1" pin="B6"/>
                <pinref part="USBC" gate="G$1" pin="A6"/>
                <wire x1="186.69" y1="62.23" x2="219.71" y2="62.23" width="0.1524" layer="91"/>
                <wire x1="219.71" y1="62.23" x2="252.73" y2="62.23" width="0.1524" layer="91"/>
                <wire x1="201.93" y1="43.18" x2="219.71" y2="43.18" width="0.1524" layer="91"/>
                <wire x1="219.71" y1="43.18" x2="219.71" y2="62.23" width="0.1524" layer="91"/>
                <wire x1="255.27" y1="57.15" x2="252.73" y2="57.15" width="0.1524" layer="91"/>
                <wire x1="252.73" y1="57.15" x2="252.73" y2="62.23" width="0.1524" layer="91"/>
                <wire x1="252.73" y1="62.23" x2="255.27" y2="62.23" width="0.1524" layer="91"/>
                <junction x="219.71" y="62.23"/>
                <junction x="252.73" y="62.23"/>
                <label x="186.69" y="62.23" size="1.778" layer="95"/>
              </segment>
              <segment>
                <pinref part="U1" gate="G$1" pin="14"/>
                <wire x1="53.34" y1="140.97" x2="57.15" y2="140.97" width="0.1524" layer="91"/>
                <label x="53.34" y="140.97" size="1.778" layer="95"/>
              </segment>
            </net>
            <net name="USB_D-" class="0">
              <segment>
                <pinref part="D8" gate="G$1" pin="1"/>
                <pinref part="USBC" gate="G$1" pin="A7"/>
                <pinref part="USBC" gate="G$1" pin="B7"/>
                <wire x1="186.69" y1="59.69" x2="215.9" y2="59.69" width="0.1524" layer="91"/>
                <wire x1="215.9" y1="59.69" x2="254" y2="59.69" width="0.1524" layer="91"/>
                <wire x1="201.93" y1="52.07" x2="215.9" y2="52.07" width="0.1524" layer="91"/>
                <wire x1="215.9" y1="52.07" x2="215.9" y2="59.69" width="0.1524" layer="91"/>
                <wire x1="255.27" y1="59.69" x2="254" y2="59.69" width="0.1524" layer="91"/>
                <wire x1="254" y1="59.69" x2="254" y2="64.77" width="0.1524" layer="91"/>
                <wire x1="254" y1="64.77" x2="255.27" y2="64.77" width="0.1524" layer="91"/>
                <junction x="215.9" y="59.69"/>
                <junction x="254" y="59.69"/>
                <label x="186.69" y="59.69" size="1.778" layer="95"/>
              </segment>
              <segment>
                <pinref part="U1" gate="G$1" pin="13"/>
                <wire x1="53.34" y1="143.51" x2="57.15" y2="143.51" width="0.1524" layer="91"/>
                <label x="53.34" y="143.51" size="1.778" layer="95"/>
              </segment>
            </net>
            <net name="VCC" class="0">
              <segment>
                <pinref part="F1" gate="G$1" pin="1"/>
                <pinref part="C13" gate="G$1" pin="2"/>
                <pinref part="D4" gate="G$1" pin="1"/>
                <wire x1="200.66" y1="100.33" x2="200.66" y2="95.25" width="0.1524" layer="91"/>
                <wire x1="200.66" y1="95.25" x2="210.82" y2="95.25" width="0.1524" layer="91"/>
                <wire x1="210.82" y1="95.25" x2="213.36" y2="95.25" width="0.1524" layer="91"/>
                <wire x1="210.82" y1="93.98" x2="210.82" y2="95.25" width="0.1524" layer="91"/>
                <junction x="210.82" y="95.25"/>
                <junction x="200.66" y="95.25"/>
                <label x="200.66" y="100.33" size="1.778" layer="95"/>
              </segment>
              <segment>
                <pinref part="Q1" gate="G$1" pin="3"/>
                <pinref part="R4" gate="G$1" pin="2"/>
                <wire x1="41.91" y1="66.04" x2="41.91" y2="69.85" width="0.1524" layer="91"/>
                <wire x1="41.91" y1="69.85" x2="52.07" y2="69.85" width="0.1524" layer="91"/>
                <wire x1="52.07" y1="69.85" x2="52.07" y2="54.61" width="0.1524" layer="91"/>
                <label x="52.07" y="69.85" size="1.778" layer="95"/>
              </segment>
              <segment>
                <pinref part="C6" gate="G$1" pin="2"/>
                <pinref part="JUMPER" gate="G$1" pin="2"/>
                <pinref part="U4" gate="G$1" pin="5"/>
                <wire x1="91.44" y1="41.91" x2="85.09" y2="41.91" width="0.1524" layer="91"/>
                <wire x1="85.09" y1="41.91" x2="85.09" y2="40.64" width="0.1524" layer="91"/>
                <wire x1="85.09" y1="69.85" x2="85.09" y2="57.15" width="0.1524" layer="91"/>
                <wire x1="85.09" y1="57.15" x2="85.09" y2="41.91" width="0.1524" layer="91"/>
                <wire x1="76.2" y1="57.15" x2="85.09" y2="57.15" width="0.1524" layer="91"/>
                <junction x="85.09" y="41.91"/>
                <junction x="85.09" y="57.15"/>
                <label x="85.09" y="69.85" size="1.778" layer="95"/>
              </segment>
              <segment>
                <pinref part="R18" gate="G$1" pin="2"/>
                <wire x1="13.97" y1="92.71" x2="15.24" y2="92.71" width="0.1524" layer="91"/>
                <label x="13.97" y="92.71" size="1.778" layer="95"/>
              </segment>
            </net>
            <net name="YELLOW_LED" class="0">
              <segment>
                <pinref part="U1" gate="G$1" pin="19"/>
                <wire x1="76.2" y1="123.19" x2="76.2" y2="127" width="0.1524" layer="91"/>
                <label x="76.2" y="123.19" size="1.778" layer="95"/>
              </segment>
              <segment>
                <pinref part="YELLOW" gate="G$1" pin="1"/>
                <wire x1="29.21" y1="105.41" x2="30.48" y2="105.41" width="0.1524" layer="91"/>
                <label x="29.21" y="105.41" size="1.778" layer="95"/>
              </segment>
            </net>
          </nets>
        </sheet>
      </sheets>
    </schematic>
  </drawing>
</eagle>