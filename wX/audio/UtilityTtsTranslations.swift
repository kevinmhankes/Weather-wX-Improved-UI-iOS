/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class UtilityTtsTranslations {

	static func translateAbbreviations(_ text: String) -> String {
		let s = text.replace("...", " ")
			.replaceAll(" \\-([0-9])", " negative $1")
			.replace(" U/L ", " upper level ")
			.replace(" DE ", " Delaware ")
			.replace("</script>", " ")
			.replace("</font>", " ")
			.replace("</TITLE>", " ")
			.replace("</HEAD>", " ")
			.replace("&nbsp", " ")
			.replace("</h4>", " ")
			.replace("</b>", " ")
			.replace("</B>", " ")
			.replace("</FONT2>", " ")
			.replace("</A>", " ")
			.replace("---", " ")
			.replace("<br>", " ")
			.replace("..", "  ")
			.replace(". ", " . ")
			.replace("; ", " ; ")
			.replace(":", " : ")
			.replace(", ", " , ")
			.replace("/", " / ")
			.replace("(", " ( ")
			.replace(")", " ) ")
			.replace("&&", " ")
			.replace("~", "")
			.replace("`", "")
			.replace("-", " - ")
			.replace("$$", " ")
		return translateAbbreviationsChunk(s)
	}

	static func translateAbbreviationsChunk(_ text: String) -> String {
		var s = text.uppercased()
		s = s.replace(" SVR ", " severe ")
			.replace(" TSTM ", " thunderstorm ")
			.replace(" TSTMS ", " thunderstorms ")
			.replace(" SWLY ", " south westerly ")
			.replace(" SWRLY ", " south westerly ")
			.replace(" SLY ", "  southerly ")
			.replace(" ELY ", "  easterly ")
			.replace(" SERN ", " south eastern ")
			.replace(" SWRN ", " south western ")
			.replace(" ERN ", " eastern ")
			.replace(" WRN ", " western ")
			.replace("TNGT ", " tonight ")
			.replace(" AOA ", " at or above ")
			.replace(" SFC ", " surface ")
			.replace(" UPR ", " upper ")
			.replace(" SSELY ", " south south easterly ")
			.replace(" ISOLD ", " isolated ")
			.replace(" DMGG ", " damaging ")
			.replace(" ATTM ", " At this time ")
			.replace(" FGEN ", " Frontogenesis ")
			.replace(" POPS ", " probability of precipitation ")
			.replace(" POP ", " probability of precipitation ")
			.replace(" OBS ", " observations ")
			.replace(" HI RES ", " high resolution ")
			.replace(" TROP ", " Tropopause ")
			.replace(" FT ", " feet ")
			.replace(" INVOF ", " in the vicinity of ")
			.replace(" CNTRL ", " central ")
			.replace(" SWD ", " southward ")
			.replace(" SWWD ", " south westward ")
			.replace(" SEWD ", " south eastward ")
			.replace(" NWWD ", " north westward ")
			.replace(" ARKLATEX ", " AR LA TX ")
			.replace(" EWD ", " eastward ")
			.replace(" NWD ", " northward ")
			.replace(" NEWD ", " north eastward ")
			.replace(" ENEWD ", " east north eastward ")
			.replace(" NWRN ", " north western ")
			.replace(" NERN ", " north eastern ")
			.replace(" NRN ", " northern ")
			.replace(" SRN ", " southern ")
			.replace(" ERN ", " eastern ")
			.replace(" WRN ", " western ")
			.replace(" NNEWD ", " north north eastward ")
			.replace(" DIABATIC ", " dia-batic ")
			.replace(" CONVECTIVELY ", " convect-ively ")
			.replace(" NLY ", " northerly ")
			.replace(" NLYS ", " northerlies ")
			.replace(" DCVA ", " Differential Cyclonic Vorticity Advection  ")
			.replace(" CAA ", " cold air advection  ")
			.replace(" WAA ", " warm air advection  ")
			.replace(" FROPA ", " frontal passage  ")
			.replace(" WINDCHILLS ", " wind chills  ")
			.replace(" POSTFRONTAL ", " post frontal  ")
			.replace(" WW ", " watch ")

		s = s.replace(" EST ", " Eastern standard time ")
			.replace(" EDT ", " Eastern day light time ")
			.replace(" MST ", " Mountain standard time ")
			.replace(" PST ", " Pacific standard time ")
			.replace(" HST ", " Hawaii Standard time ")
			.replace(" AKST ", " Alaska Standard time ")

		s = s.replace(" EDT ", " Eastern day light time ")
			.replace(" CDT ", " Central day light time ")
			.replace(" PDT ", " Pacific day light time ")
			.replace(" AKDT ", " Alaska day light time ")

		s = s.replace(" SE ", " south east ")
			.replace(" PCPN ", " precipitation ")
			.replace(" BKN ", " BROKEN ")
			.replace(" SCT ", " SCATTERED ")
			.replace(" ST ", " SAINT ")
			.replace(" PTS ", " points ")
			.replace(" CIGS ", " CEILING ")
			.replace(" CIG ", " CEILING ")
			.replace(" AOB ", " at or above ")
			.replace(" MB ", " MILLIBARS ")
			.replace(" VFR ", " VISUAL FLIGHT RULES ")
			.replace(" MVFR ", " MARGINAL VISUAL FLIGHT RULES ")
			.replace(" IFR ", " INSTRUMENT FLIGHT RULES ")
			.replace(" LIFR ", " low instrument flight rules ")
			.replace(" KT ", " KNOTS ")
			.replace(" MP ", " MARITIME POLAR ")
			.replace(" CP ", " CONTINENTAL POLAR ")
			.replace(" PRECIP ", " precipitation ")
			.replace(" FCST ", " forecast ")
			.replace(" SOLNS ", " solutions ")
			.replace(" SOLN ", " solution ")
			.replace(" PAC ", " Pacific ")
			.replace(" ATL ", " Atlantic ")
			.replace(" SHRTWV ", " short wave ")
			.replace(" VISIBILITIES ", " visibility ")
			.replace(" NOAM ", " north america ")
			.replace(" HRS ", " hours ")
			.replace(" AVG ", " average ")
			.replace(" PCT ", " percent ")
			.replace(" HGT ", " height ")
			.replace(" HVY ", " heavy ")
			.replace(" IT ", " it ")
			.replace(" C ", " celsius ")
			.replace(" RNFL ", " rain fall ")
			.replace(" ELEV ", " elevations ")
			.replace(" PROGGED ", " forecasted ")
			.replace(" GRTLKS ", " great lakes ")
			.replace(" GRTBASIN ", " great basin ")
			.replace(" MSTR ", " moisture ")
			.replace(" PROB ", " probability ")
			.replace(" MIN ", " minimum ")
			.replace(" NE ", " north east ")
			.replace(" ENE ", " east north east ")
			.replace(" N ", " north ")
			.replace(" S ", " south ")
			.replace(" E ", " east ")
			.replace(" W ", " west ")
			.replace(" WSW ", " west southwest ")
			.replace(" NW ", " north west ")
			.replace(" ESE ", " east south east ")
			.replace(" NNE ", " north northeast ")
			.replace(" SSW ", " south south west ")
			.replace(" SSWWD ", " south south westward ")
			.replace(" SW ", " south west ")

		s = s.replace(" BAROCLINIC ", " baro clinic ")
			.replace("*", " ")
			.replace(" TROF ", " trough ")
			.replace(" KTS ", " knots ")
			.replace(" HRLY ", " hourly ")
			.replace(" U/L ", " upper level ")
			.replace(" MRGL ", " marginal ")
			.replace(" ENH ", " enhanced ")
			.replace(" SLGT ", " slight ")
			.replace(" MDT RISK ", " moderate risk ")
			.replace(" STG ", " strong ")
			.replace(" ATLC ", " atlantic ")
			.replace(" REF ", " reference ")
			.replace(" PRES ", " pressure ")
			.replace(" VWP ", " VAD wind profile ")
			.replace(" VWPS ", " VAD wind profiles ")
			.replace(" HODOGRAPH", " hodo graph")
			.replace(" DELMARVA ", " DE MD VA ")
			.replace(" LWR ", " lower ")
			.replace(" LVLS ", " levels ")
			.replace(" LVL ", " level ")
			.replace(" WDLY ", " widely ")
			.replace(" SCTD ", " scattered ")
			.replace(" EVE ", " evening ")
			.replace(" VLY ", " valley ")
			.replace(" VLYS ", " valleys ")
			.replace(" RCKYS ", " rockies ")
			.replace(" ISOLD ", " isolated ")
			.replace(" RH ", " relative humidity ")

		s = s.replace(" AGL ", " above ground level ")
			.replace(" AFTN ", " afternoon ")
			.replace(" ASL ", " above sea level ")
			.replace(" BLO ", " below ")
			.replace(" BLZD ", " blizzard ")
			.replace(" BRF ", " brief ")
			.replace(" BTWN ", " between ")
			.replace(" BS ", " blowing snow ")
			.replace(" BTR ", " better ")
			.replace(" BWER ", " bounded weak echo region ")
			.replace(" BYD ", " beyond ")
			.replace(" CAD ", " cold air damming ")
			.replace(" CDFNT ", " cold front ")
			.replace(" CEM ", " civil emergency message ")
			.replace(" CFP ", " cold front passage ")
			.replace(" CHC ", " chance ")
			.replace(" CHG ", " changes ")
			.replace(" CHGS ", " cold front ")
			.replace(" CLR ", " clearing ")
			.replace(" CNVG ", " converge ")
			.replace(" CNVTV ", " convective ")
			.replace(" COND ", " condition ")
			.replace(" CSTL ", " coastal ")
			.replace(" CTY ", " city ")
			.replace(" CYC ", " cycone ")
			.replace(" CYCLGN ", " cyclo-genesis ")
			.replace(" CYCLOGENESIS ", " cyclo-genesis ")
			.replace(" MIDLEVEL ", " mid-level ")
			.replace(" BNDRY ", " boundary ")

		s = s.replace(" AMTS ", " amounts ")
			.replace(" FNT ", " front ")
			.replace(" PTYPE ", " precipitation type ")
			.replace(" DWPTS ", " dew points ")
			.replace(" SNWFL ", " snow fall ")

		s = s.replace(" FRONTOGENESIS ", " front O genesis ")
			.replace(" GEN ", " general ")
			.replace(" LTG ", " light ")
			.replace(" FRONTOGENETIC ", " front O genetic ")
			.replace(" DWPT ", " dew point ")
			.replace(" ESP ", " especially ")
			.replace(" CLIMO ", " climatological ")
			.replace(" SNE ", " southern new england ")

		s = s.replace(" ACCUM ", " accumulation ")
			.replace(" 20S ", " twenties ")
			.replace(" 30S ", " thirties ")
			.replace(" 40S ", " forties ")
			.replace(" 50S ", " fifties ")
			.replace(" 60S ", " sixties ")
			.replace(" 70S ", " seventies ")
			.replace(" 80S ", " eighties ")
			.replace(" 90S ", " nineties ")
			.replaceAll("([0-9])MB ", "$1 millibars ")
			.replaceAll("([0-9])KTS ", "$1 knots ")
			.replaceAll("([0-9])KT ", "$1 knots ")
			.replaceAll("([0-9])F ", "$1 farenheit ")
			.replaceAll("([0-9])KFT ", "$1 thousand feet ")
			.replaceAll("([0-9])K ", "$1 thousand ")
			.replaceAll("([0-9])C ", "$1 celsius ")
			.replaceAll("([0-9])CM ", "$1 centimeters ")
			.replaceAll("([0-9][0-9] AM )", ":$1")
			.replaceAll("([0-9][0-9] PM )", ":$1")
			.replaceAll("(DAY)([0-9])", "$1 $2")
			.replace(" FGEN ", " front O genesis ")

		s = s.replace(" SN ", " snow ")
			.replace(" BR ", " mist ")
			.replace(" VSBYS ", " visibility ")
			.replace(" ACCUMS ", " accumulations ")
			.replace(" SSERLY ", " south southeasterly ")
			.replace(" BLW ", " below ")
			.replace(" KFT ", " thousand feet ")
			.replace(" TUES ", " tuesday ")
			.replace(" WLY ", " westerly ")
			.replace(" STD ", " standard ")
			.replace(" DEV ", " deviation ")
			.replace(" NGT ", " night ")
			.replace(" SHRAS ", " showers ")
			.replace(" ERY ", " early ")
			.replace(" AVGG ", " averaging ")
			.replace(" MRNG ", " morning ")
			.replace(" INCRS ", " increase ")
			.replace(" ARND ", " around ")
			.replace(" VRBL ", " variable ")
			.replace(" CHCS ", " chances ")
			.replace(" TMRW ", " tomorrow ")
			.replace(" APCHG ", " approaching ")
			.replace(" LLVL ", " low level ")
			.replace(" DZ ", " drizzle ")
			.replace(" FZDZ ", " freezing drizzle ")
			.replace(" HRS ", " hours ")
			.replace(" WX ", " weather ")
			.replace(" DEGS ", " degrees ")
			.replace(" PACNW ", " pacific northwest ")
			.replace(" NR ", " near ")
			.replace(" WNW ", " west northwest ")
			.replace(" NWLY ", " north westerly ")
			.replace(" WNWLY ", " west north westerly ")
			.replace(" FM ", " from ")
			.replace(" WK ", " weak ")
			.replace(" LYR ", " layer ")
			.replace(" MTNS ", " mountains ")
			.replace(" NNW ", " north northwest ")
			.replace(" SHSN ", " snow showers ")
			.replace(" LLEVEL ", " low level ")
			.replace(" SWR ", " south western ")
			.replace(" PTSUNNY ", " partly sunny ")
			.replace(" SST ", " sea surface temperature ")
			.replace(" CONDS ", " conditions ")
			.replace(" PSBL ", " possible ")
			.replace(" FZRA ", " freezing rain ")
			.replace(" SK ", " Saskatchewan ")
			.replace(" AB ", " Alberta ")
			.replace(" IP ", " sleet ")
			.replace(" CAL ", " california ")

		s = s.replace(" VRB ", " variable ")
			.replace(" SHRA ", " rain showers ")
			.replace(" SLY ", " visibility ")
			.replace(" DEAMPLIFIES ", " de-amplifies ")
			.replace(" LLJ ", " low level jet ")
			.replace(" ULJ ", " upper level jet ")
			.replace(" WLYS ", " westerlies ")
			.replace(" MOISTENING ", " moisten-ing ")
			.replace(" MUCAPE ", " most unsable CAPE ")
			.replace(" MLCAPE ", " mixed layer CAPE ")
			.replace(" SBCAPE ", " surface based CAPE ")
			.replace(" DEWPOINTS ", " dew points ")
			.replace(" MOVG ", " moving ")
			.replace(" SSE ", " south southeast ")
			.replace(" VS ", " versus ")
			.replace(" EQUIVS ", " equivalent ")
			.replace(" GT ", " great ")
			.replace(" PD ", " period ")
			.replace(" ACRS ", " across ")
			.replace(" MTN ", " mountain ")
			.replace(" PROBS ", " probabilities ")
			.replace(" THURS ", " thursday ")
			.replace(" TROUGHING ", " trough-ing ")
			.replace(" STEEPENING ", " steepen-ing ")
			.replace(" ANTICYCLONIC ", " anti-cyclonic ")
			.replace(" SCNTL ", " south central ")
			.replace(" SCNTRL ", " south central ")
			.replace(" VIS ", " visibility ")

		s = s.replace(" MX ", " Mexico ")
			.replace(" ADVECT ", " ad-vet ")
			.replace(" ADVECTS ", " ad-vets ")
			.replace(" ADVECTING ", " ad-veting ")
			.replace(" SSWLY ", " south southwesterly ")
			.replace(" PROG ", " forecast ")
			.replace(" PROGS ", " forecast ")
			.replace(" DEAMPLIFYING ", " de-amplifying ")
			.replace(" DEAMPLIFY ", " de-amplify ")
			.replace(" OVR ", " over ")
			.replace(" WL ", " will ")
			.replace(" MAX ", " maximum ")
			.replace(" VORT ", " vorticity ")
			.replace(" STNRY ", " stationary ")
			.replace(" MTS ", " mountains ")

		s = s.replace(" NRN ", " northern ")
			.replace(" DFW ", " Dallas Fort Worth ")
			.replace(" SM ", " statue miles ")
			.replace(" VLIFR ", " very low instrument flight rules ")
			.replace(" VISBYS ", " visibility ")
			.replace(" NVA ", " negative vorticity ad-vetion ")
			.replace(" VSBY ", " visibility ")
			.replace(" USVI ", " US virgin islands ")
			.replace(" WDSPRD ", " widespread ")
			.replace(" SLYS ", " southerlies ")
			.replace(" SWLYS ", " south westerlies ")
			.replace(" WSWLYS ", " west south westerlies ")
			.replace(" ASCT ", " associated ")
			.replace(" ASSOC ", " associated ")
			.replace(" PR ", " Puerto Rico ")
			.replace(" PREV ", " previous ")
			.replace(" TWRDS ", " towards ")
			.replace(" CNTL ", " central ")
			.replace(" ESEWD ", " east south eastward ")
			.replace(" SSEWD ", " south south eastward ")
			.replace(" WSWLY ", " west south westerly ")
			.replace(" LGT ", " light ")
			.replace(" NUM ", " numerous ")
			.replace(" EVNG ", " evening ")
			.replace(" COV ", " coverage ")
			.replace(" ISLTD ", " isolated ")
			.replace(" OVR ", " over ")
			.replace(" TSRA ", " thunderstorms ")
			.replace(" ABV ", " above ")
			.replace(" LL ", " lower level ")
			.replace(" MDLS ", " models ")
			.replace(" RETROGRADING ", " retrograde-ing ")
			.replace(" MDL ", " model ")

		s = s.replace(" MVNG ", " moving ")
			.replace(" SRLY ", " southerly ")
			.replace(" AGRMNT ", " agreement ")
			.replace(" ASSD ", " associated ")
			.replace(" AHD ", " ahead ")
			.replace(" ADVNCNG ", " advancing ")
			.replace(" QSTN ", " quasi-stationary ")
			.replace(" WHTHR ", " weather ")
			.replace(" ASSD ", " associated ")
			.replace(" IMMED ", " immediately ")
			.replace(" DMNSHNG ", " diminishing ")
			.replace(" LRG ", " large ")
			.replace(" PRBLM ", " problem ")
			.replace(" CNDN ", " Canadian ")
			.replace(" DVLP ", " develop ")
			.replace(" ENCMBL ", " ensemble ")
			.replace(" NFNLND ", " Newfoundland ")
			.replace(" CNFDC ", " confidence ")
			.replace(" HVNG ", " having ")
			.replace(" DFFCLTS ", " difficulties ")
			.replace(" SMLR ", " similar ")
			.replace(" FLLWD ", " followed ")
			.replace(" INBTWN ", " in between ")
			.replace(" GDNC ", " guidance ")
			.replace(" STRNG ", " strong ")
			.replace(" IND ", " Indiana ")
			.replace(" HWY ", " highway ")
			.replace(" STEEPEN ", " steep-en ")
			.replace(" CONVECTION ", " convect-ion ")
			.replace(" OFFSHR ", " off-shore ")

		s = s.replace(" TROUGHED ", " trough-ed ")
			.replace(" NEB ", " Nebraska ")

		s = s.replace(" RADIATIONAL ", " radiation-al ")
			.replace(" BOMBOGENESIS  ", " bomb O genenesis ")
			.replace(" BAROCLINICITY ", " baro-clinicity ")
			.replace(" PROBABILISTIC ", " probabilistic ")
			.replace(" CYCLONICALLY  ", " cyclonic-ally ")

		s = s.replace(" CNTR ", " central ")
			.replace(" BC ", " British Columbia ")
			.replace(" TELECONNECTIONS ", " tele-connections ")
			.replace(" POS ", " possible ")
			.replace(" F ", " farenheit ")
			.replace(" SELY ", " south-easterly ")
			.replace(" MINS ", " minimums ")
			.replace(" US ", " us ")
			.replace(" DEG ", " degrees ")
			.replace(" DEGS ", " degrees ")
			.replace(" RAOB ", " radiosonde observation ")
			.replace(" RAOBS ", " radiosonde observations ")
			.replace(" POSN ", " position ")

		s = s.replace(" PSBLY ", " possibly ")
			.replace(" PREFS  ", " preferences ")
			.replace(" FCSTS ", " forecasts ")
			.replace(" WWD ", " westward ")
			.replace(" ESELY ", " east south-easterly ")
			.replace(" OVERSPREAD ", " over spread ")
			.replace(" UNK ", " unknown ")
			.replace(" DIFFS ", " differences ")

		s = s.replace(" MPH ", " miles per hour ")
			.replace(" SHRTWVS  ", " short waves ")
			.replace(" WSWWD  ", " west south westward ")
			.replace("GRAPHICS AVAILABLE AT WWW.WPC.NCEP.NOAA.GOV", " ")
			.replace("PLEASE SEE WWW.SPC.NOAA.GOV / FIRE FOR GRAPHIC PRODUCT", " ")
			.replace(" NCNTRL ", " north central ")

		s = s.replace(" STRATOCU ", " strato-cumulous ")
			.replace(" KM ", " kilometers ")

		s = s.replace(" JETLET ", " jet let ")
			.replace(" IT ", " it ")
			.replace(" WCNTRL ", " west central ")
			.replace(" MAR ", " March ")
			.replace(" FEB ", " February ")
			.replace(" JAN ", " January ")
			.replace(" APR ", " April ")
			.replace(" JUN ", " June ")
			.replace(" JUL ", " July ")
			.replace(" AUG ", " August ")
			.replace(" SEP ", " September ")
			.replace(" OCT ", " October ")
			.replace(" NOV ", " November ")
			.replace(" DEC ", " December ")
			.replace(" HYDROMETEORS ", " hydro-meteors ")

		s = s.replace(" ONT ", " Ontario ")
			.replace(" QUE ", " Quebec ")

		s = s.replace(" STRATIFORM ", " strati-form ")
			.replace(" HR ", " hour ")
			.replace(" WINDSPEEDS ", " wind speeds ")
			.replace(" JETLETS ", " jet lets ")
			.replace(" ANAFRONTAL ", " anna-frontal ")
			.replace(" HR ", " hour ")

		s = s.replace(" EMBDD ", " embedded ")
			.replace(" CM ", " centimeters ")
			.replace(" UHI ", " urban heat island ")
			.replace(" SCHC ", " slight chance ")
			.replace(" SIG ", " significant ")

		s = s.replace(" RA ", " rain ")
			.replace(" SN ", " snow ")
			.replace(" LO ", " low ")
			.replace(" ENUF ", " enough ")
			.replace(" HGTS ", " heights ")
			.replace(" GNRL ", " general ")
			.replace(" RDG ", " ridge ")
			.replace(" ALG ", " along ")
			.replace(" RJCTD ", " rejected ")
			.replace(" WNDS ", " winds ")
			.replace(" OBSN ", " observations ")
			.replace(" WTRS ", " waters ")
			.replace(" ADDNLY ", " additionally ")
			.replace(" YK ", " Yukon ")
			.replace(" YT ", " Yukon ")
			.replace(" NU ", " Nunavut ")
			.replace(" NB ", " New Brunswick ")
			.replace(" NF ", " Newfoundland ")
			.replace(" NWT ", " Northwest Terroritories ")
			.replace(" NT ", " Northwest Terroritories ")
			.replace(" RGNS ", " regions ")
			.replace(" ESPLY ", " especially ")
			.replace(" SVRL ", " several ")
			.replace(" FCSTG ", " forecasting ")
			.replace(" XPCTG ", " expecting ")
			.replace(" WRM ", " warm ")
			.replace(" HWVR ", " however ")
			.replace(" PD ", " period ")

		s = s.replace(" RMNS ", " remains ")
			.replace(" DPNG ", " deepening ")
			.replace(" ATLC ", " Atlantic ")
			.replace(" JMSBA ", " James Bay ")
			.replace(" SHUD ", " should ")
			.replace(" DP ", " deep ")
			.replace(" VCISLD ", " Vancouver Island ")
			.replace(" SVRL ", " several ")
			.replace(" GLFALSK ", " Gulf of Alaska ")
			.replace(" WK ", " weak ")
			.replace(" QC ", " Quebec ")
			.replace(" QB ", " Quebec ")
			.replace(" PEI ", " Prince Edward Island ")
			.replace(" NS ", " Nova Scotia ")
			.replace(" FZ ", " freezing ")
			.replace(" SYS ", " system ")
			.replace(" ERLY ", " early ")
			.replace(" ASOCTD ", " associated ")
			.replace(" SLTN ", " solution ")
			.replace(" BTN ", " between ")
			.replace(" BHND ", " behind ")
			.replace(" SEV ", " severe ")
			.replace(" LABRDR ", " Labrador ")
			.replace(" BTN ", " between ")
			.replace(" PSN ", " position ")
			.replace(" LUK ", " look ")
			.replace(" RSNBL ", " reasonable ")
			.replace(" ALSK ", " Alaska ")
			.replace(" PNHDL ", " pan-handle ")
			.replace(" GUD ", " good ")
			.replace(" AGRMT ", " agreement ")
			.replace(" HIER ", " higher ")
			.replace(" EXP ", " expect ")
			.replace(" CTRL ", " central ")
			.replace(" BDRY ", " boundary ")
			.replace(" XTNDG ", " extending ")
			.replace(" XTNDD ", " extended ")
			.replace(" NFLD ", " Newfoundland ")
			.replace(" BTN ", " between ")
			.replace(" KM / H ", " kilometers per hour ")
			.replace(" LO ", " low ")

		s = s.replace(" WTRS ", " waters ")
			.replace(" LBRDR ", " Labrador ")
			.replace(" LK ", " lake ")
			.replace(" LKSUPR ", " Lake Superior")
			.replace(" MOVG ", " moving ")
			.replace(" NMRCLS MLDS ", " numerical models ")
			.replace(" ONSHR ", " onshore ")
			.replace(" OCN ", " ocean ")
			.replace(" SXNS ", " sections ")
			.replace(" GUIDANCES ", " guidance ")
			.replace(" SXNS ", " sections ")
			.replace(" EPAC ", " Eastern Pacific ")
			.replace(" OA ", " objective analysis ")
			.replace(" ADDNLY ", " additionally ")

		s = s.replace(" WKNG ", " weakening ")
			.replace(" FEAT ", " feature ")
			.replace(" MLDS ", " models ")
			.replace(" NMRCLS ", " numerical ")
			.replace(" LUKS ", " looks ")
			.replace(" DIFF ", " differences ")
			.replace(" ARK ", " Arkansas ")
			.replace(" PE ", " Prince Edward Island ")
			.replace(" NELY ", " north-easterly ")
			.replace(" MRTMS ", " martimes ")

		s = s.replace(" PT ", " points ")
			.replace(" XTRM ", " extreme ")
			.replace(" XTDG ", " extending ")
			.replace(" SUP ", " Superior ")
			.replace(" OBNS ", " observations ")
			.replace(" MM ", " millimeters ")
			.replace(" LAWR ", " Lawrence ")

		s = s.replace(" TROFS ", " troughs ")
			.replace(" TRAJ ", " trajectory ")
			.replace(" SIGLY ", " significantly ")
			.replace(" RGNS ", " regions ")
			.replace(" FNTL ", " frontal ")
			.replace(" CDN ", " Canadian ")
			.replace(" H ", " hour ")
			.replace(" TWD ", " toward ")
			.replace(" EDG ", " edge ")
			.replace(" RGN ", " region ")

		s = s.replace(" HV ", " have ")
			.replace(" HVG ", " having ")
			.replace(" ISENTROPIC ", " isen-tropic ")
			.replace(" VERIF ", " verify ")
			.replace(" MKS ", " makes ")
			.replace(" GNRLY ", " generally ")
			.replace(" CSTS ", " coasts ")
			.replace(" SHORTWV ", " short-wave ")
			.replace(" OBJ ", " objective ")
			.replace(" WINTERSTORM ", " winter storm ")

		s = s.replace(" PROBLY ", " probably ")
			.replace(" RJCT ", " reject ")
			.replace(" WTR ", " water ")
			.replace(" DVLPMNT ", " development ")
			.replace(" DVLPMT ", " development ")
			.replace(" WKN ", " weaken ")
			.replace(" HDSNBA ", " Hudson Bay ")
			.replace(" LTL ", " little ")
			.replace(" AGMT ", " agreement ")
			.replace(" ADDNL ", " additional ")
			.replace(" DVLPG ", " developing ")
			.replace(" UPSLP ", " up-slope ")
			.replace(" XPCTD ", " expected ")
			.replace(" PANHDL ", " pan handle ")
			.replace(" MVS ", " moves ")
			.replace(" ISENTROPIC ", " ice-tropic ")
			.replace(" LT ", " late ")

		s = s.replace(" EQUIV ", " equivalent ")
			.replace(" PROV ", " provinces ")
			.replace(" WVS ", " waves ")
			.replace(" AKPNHDL ", " Alaska pan handle ")
			.replace(" OTWZ ", " otherwise ")
			.replace(" VRISL ", " Vancouver Island ")
			.replace(" VRISLD ", " Vancouver Island ")
			.replace(" SNSQ ", " snow squall ")
			.replace(" BLSN ", " blowing snow ")
			.replace(" FLO ", " flow ")
			.replace(" UPSLO ", " up slope ")
			.replace(" THO ", " though ")
			.replace(" FTR ", " further ")
			.replace(" MVG ", " moving ")
			.replace(" MV ", " move ")
			.replace(" THRU ", " though ")
			.replace(" LOS ", " lows ")
			.replace(" XTND ", " extended ")

		s = s.replace("NORMAN OK", "Norman Oklahoma")

		s = s.replace(" DRYLINE ", " dry line ")
			.replace(" SUPERCELLULAR ", " super cellular ")
			.replace(" WSWWD ", " west south westward ")
			.replace(" THERMODYNAMICALLY ", " thermo-dynamically ")
			.replace(" CINH ", " convective inhibition ")
			.replace(" MULTICELLS ", " multi-cells ")
			.replace(" MULTICELL ", " multi-cell ")
			.replace(" EASTWARDS ", " eastward ")
			.replace(" SOUTHEASTWARDS ", " south eastward ")
			.replace(" SOUTHWESTWARDS ", " south westward ")
			.replace(" BL ", " boundary layer ")
			.replace(" FQT ", " frequent ")
			.replace(" GTE ", " greater than or equal ")
			.replace(" GOM ", " Gulf of Mexico ")
			.replace(" SWERLY ", " south westerly ")
			.replace(" LI ", " lifted index ")
			.replace(" SLWR ", " slower ")
			.replace(" CONV ", " convective ")
			.replace(" CONVN ", " convective ")
			.replace(" QN ", " question ")
			.replace(" RTN ", " return ")
			.replace(" XPCD ", " expected ")
			.replace(" FLW ", " flow ")
			.replace(" SHLD ", " should ")
			.replace(" OTRWS ", " otherwise ")
			.replace(" CU ", " cumulus ")
			.replace(" TSARS ", " thunder storms ")
			.replace(" SOUTHWESTWARD ", " south westward ")

		s = s.replace(" POTNL ", " potential ")
			.replace(" ESPCLY ", " especially ")
			.replace(" PRBLY ", " probably ")
			.replace(" CONTD ", " continued ")
			.replace(" PLNS ", " plains ")
			.replace(" GRT ", " great ")
			.replace(" LKS ", " lakes ")
			.replace(" QSTNRY ", " quasi stationary ")
			.replace(" TS ", " thunderstorms ")

		s = s.replace(" ISO-SCT ", " isolated to scattered ")
			.replace(" WKND ", " weekend ")
			.replace(" PRES ", " pressure ")
			.replace(" LO ", " low ")
			.replace(" CONT ", " continue ")
			.replace(" FNT ", " front ")
			.replace(" STM ", " storm ")
			.replace(" INCRSG ", " increasing ")
			.replace(" SGFNT ", " significant ")
			.replace(" PTNTLLY ", " potentially ")

		s = s.replace(" WKNS ", " weakens ")
			.replace(" DVLPS ", " develops ")
			.replace(" GVG ", " giving ")
			.replace(" OFSHR ", " off shore ")
			.replace(" PRS ", " pressure ")
			.replace(" INDCTG ", " indicating ")
			.replace(" FRNT ", " front ")
			.replace(" LCTD ", " located ")
			.replace(" APPRCHG ", " approaching ")
			.replace(" CD ", " cold ")
			.replace(" LCTD ", " located ")
			.replace(" LTST ", " latest ")
			.replace(" SHWNG ", " showing ")
			.replace(" ADDNTL ", " additional ")
			.replace(" NXT ", " next ")
			.replace(" PTCHY ", " patchy ")
			.replace(" CNDTNS ", " conditions ")
			.replace(" RCVD ", " recieved ")
			.replace(" XPCT ", " expect ")
			.replace(" CNDTNS ", " conditions ")
			.replace(" THRUT ", " through out ")

		s = s.replace(" PATTN ", " pattern ")
			.replace(" CNTRD ", " centered ")
			.replace(" INAVD ", " in advance ")
			.replace(" SHRT ", " short ")

		s = s.replace(" AL ", " Alabama ")
			.replace(" AK ", " Alaska ")
			.replace(" AZ ", " Arizona ")
			.replace(" AR ", " Arkansas ")
			.replace(" CA ", " California ")
			.replace(" CO ", " Colorado ")
			.replace(" CT ", " Connecticut ")
			.replace(" FL ", " Florida ")
			.replace(" GA ", " Georgia ")
			.replace(" ID ", " Idaho ")
			.replace(" IL ", " Illinois ")
			.replace(" IA ", " Iowa ")
			.replace(" KS ", " Kansas ")
			.replace(" KY ", " Kentucky ")
			.replace(" LA ", " Louisiana ")
			.replace(" ME ", " Maine ")
			.replace(" MD ", " Maryland ")
			.replace(" MA ", " Massachusetts ")
			.replace(" MI ", " Michigan ")
			.replace(" MN ", " Minnesota ")
			.replace(" MS ", " Mississippi ")
			.replace(" MO ", " Missouri ")
			.replace(" MT ", " Montana ")
			.replace(" NE ", " Nebraska ")
			.replace(" NV ", " Nevada ")
			.replace(" NH ", " New Hampshire ")
			.replace(" NJ ", " New Jersey ")
			.replace(" NY ", " New York ")
			.replace(" NC ", " North Carolina ")
			.replace(" ND ", " North Dakota ")
			.replace(" OH ", " Ohio ")
			.replace(" ORE ", " Oregon ")
			.replace(" PA ", " Pennsylvania ")
			.replace(" RI ", " Rhode Island ")
			.replace(" SC ", " South Carolina ")
			.replace(" SD ", " South Dakota ")
			.replace(" TN ", " Tennessee ")
			.replace(" TX ", " Texas ")
			.replace(" UT ", " Utah ")
			.replace(" VT ", " Vermont ")
			.replace(" VA ", " Virginia ")
			.replace(" WA ", " Washington ")
			.replace(" WI ", " Wisconsin ")
			.replace(" WY ", " Wyoming ")

		s = s.replace(" FRI ", " Friday ")
			.replace(" MON ", " Monday ")
			.replace(" TUE ", " Tuesday ")
			.replace(" WED ", " Wednesday ")
			.replace(" THU ", " Thursday ")
			.replace(" SAT ", " Saturday ")
        
        // 2021-07-24
        s = s.replace("PWAT", "Precipitable Water")

		return s
	}
}
