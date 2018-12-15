/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class UtilityModelESRLInterface {

    static let models = [
        "HRRR",
		"HRRR_AK",
		"HRRR_NCEP",
		"RAP",
		"RAP_NCEP"
    ]

	static let sectorsHrrr = [
			"Full",
			"NW",
			"NC",
			"NE",
			"SW",
			"SC",
			"SE",
			"GL",
			"NE CO",
			"SEA",
			"SFO",
			"MKX",
			"OKX",
			"IAD",
			"MIA",
			"ATL",
			"CLE"
	]

	static let sectorsHrrrAk = [
			"Full"
	]

	static let modelHrrrParams = [
			"1ref_sfc",
			"cref_sfc",
			"cref_esbl",
			"mref_sfc",
			"ref_m10",
			"G113bt_sat",
			"G123bt_sat",
			"G114bt_sat",
			"G124bt_sat",
			"cape_sfc",
			"cin_sfc",
			"mxcp_sfc",
			"mucp_sfc",
			"mulcp_sfc",
			"bli_sfc",
			"lcl_sfc",
			"s1shr_sfc",
			"6kshr_sfc",
			"1hsm_sfc",
			"3hsm_sfc",
			"hlcy_sfc",
			"hlcy_esbl",
			"ca1_sfc",
			"ca2_sfc",
			"ca3_sfc",
			"ci1_sfc",
			"ci2_sfc",
			"ci3_sfc",
			"ltg1_sfc",
			"ltg2_sfc",
			"ltg3_sfc",
			"vig_sfc",
			"wind_max",
			"wind_10m",
			"gust_10m",
			"wind_80m",
			"wchg_80m",
			"wchg_esbl",
			"temp_sfc",
			"temp_2m",
			"temp_2ds",
			"dewp_2m",
			"rh_2m",
			"sfcp_sfc",
			"pchg_sfc",
			"pwtr_sfc",
			"weasd_sfc",
			"1hsnw_sfc",
			"acsnw_sfc",
			"snod_sfc",
			"acsnod_sfc",
			"acsnw_esbl",
			"acsnw_esblmn",
			"3hap_sfc",
			"acp_esbl",
			"acp_esblmn",
			"hvyacp_esbl",
			"totp_sfc",
			"totp_esbl",
			"totp_esblmn",
			"ptyp_sfc",
			"cpofp_sfc",
			"ssrun_sfc",
			"3hssrun_sfc",
			"temp_925",
			"temp_850",
			"wind_850",
			"rh_850",
			"rh_500",
			"rhpw_sfc",
			"temp_700",
			"vvel_700",
			"mnvv_sfc",
			"wind_mup",
			"wind_mdn",
			"temp_500",
			"vort_500",
			"wind_250",
			"vis_sfc",
			"tcc_sfc",
			"lcc_sfc",
			"mcc_sfc",
			"hcc_sfc",
			"ctop",
			"ceil",
			"ectp_sfc",
			"vil_sfc",
			"rvil_sfc",
			"flru_sfc",
			"ulwrf_nta",
			"solar_sfc"
	]

	static let modelHrrrLabels = [
			"1 km agl reflectivity",
			"composite reflectivity",
			"ensemble comp reflectivity",
			"max 1 km agl reflectivity",
			"-10C isothermal reflectivity",
			"GOES-W water vapor",
			"GOES-E water vapor",
			"GOES-W Infrared",
			"GOES-E Infrared",
			"surface CAPE",
			"surface CIN",
			"mixed CAPE",
			"most unstable CAPE",
			"most unstable layer CAPE",
			"best LI",
			"LCL",
			"0-1 km shear",
			"0-6 km shear",
			"0-1 km helicity, storm motion",
			"0-3 km helicity, storm motion",
			"2-5 km max updraft helicity",
			"ensemble updraft helicity",
			"convective activity 1",
			"convective activity 2",
			"convective activity 3",
			"convective initiation 1",
			"convective initiation 2",
			"convective initiation 3",
			"lightning threat 1",
			"lightning threat 2",
			"lightning threat 3",
			"max vert int graupel",
			"max 10m wind",
			"10m wind",
			"10m wind gust",
			"80m wind",
			"1h 80m wind speed change",
			"ensemble 1h 80m wind speed change",
			"skin temp",
			"2m temp",
			"2m temp - skin temp",
			"2m dew point",
			"2m RH",
			"surface pressure",
			"3h pressure change",
			"precipitable water",
			"snow water equiv",
			"1h snowfall",
			"total acc snowfall (10-1)",
			"snow depth",
			"acc snow depth (var dens)",
			"ensemble acc snowfall",
			"mean ensemble acc snowfall",
			"1h precip",
			"ensemble 1h precip",
			"mean ensemble 1h precip",
			"ensemble 1h heavy precip",
			"total acc precip",
			"ensemble total acc precip",
			"mean ensemble total acc precip",
			"precip type",
			"frozen precip percentage",
			"1h storm surface runoff",
			"3h storm surface runoff",
			"925mb temp",
			"850mb temp",
			"850mb wind",
			"850mb rh",
			"850-500mb mean rh",
			"rh with respect to pw",
			"700mb temp",
			"700mb vvel",
			"mean vvel",
			"max updraft",
			"max downdraft",
			"500mb temp",
			"500mb vort",
			"250mb wind",
			"visibility",
			"total cloud cover",
			"low-level cloud cover",
			"mid-level cloud cover",
			"high-level cloud cover",
			"cloud top height",
			"ceiling",
			"echotop height",
			"VIL",
			"RADAR VIL",
			"aviation flight rules",
			"outgoing longwave radiation",
			"incoming shortwave radiation "
	]

	static let sectorsRap = [
			"Full", "CONUS", "NW", "NC", "NE", "SW", "SC", "SE", "GL", "AK", "AK2", "HI"
	]

	static let modelRapParams = [
			"cref_sfc",
			"cape_sfc",
			"cin_sfc",
			"mxcp_sfc",
			"mucp_sfc",
			"mulcp_sfc",
			"ltng_sfc",
			"wind_10m",
			"wind_80m",
			"gust_10m",
			"temp_sfc",
			"temp_2m",
			"ptemp_2m",
			"temp_2ds",
			"dewp_2m",
			"rh_2m",
			"pwtr_sfc",
			"weasd_sfc",
			"1hsnw_sfc",
			"snod_sfc",
			"temp_925",
			"temp_850",
			"wind_850",
			"wmag_850",
			"rh_850",
			"rh_500",
			"rhpw_sfc",
			"temp_700",
			"vvel_700",
			"temp_500",
			"vort_500",
			"wind_250",
			"wmag_250",
			"vis_sfc",
			"ctop",
			"cctop",
			"ceil",
			"ectp_sfc",
			"vil_sfc",
			"rvil_sfc",
			"tcc_sfc",
			"lcc_sfc",
			"mcc_sfc",
			"hcc_sfc",
			"flru_sfc",
			"fog",
			"glw",
			"swdown",
			"sh",
			"lhtfl_sfc",
			"shtfl_sfc",
			"hpbl_sfc",
			"soilt_1cm",
			"soilt_4cm",
			"soilt_10cm",
			"soilw_sfc",
			"soilw_1cm",
			"soilw_4cm",
			"soilw_10cm"
	]

	static let modelRapLabels = [
			"reflectivity",
			"surface CAPE",
			"surface CIN",
			"mixed CAPE",
			"most unstable CAPE",
			"most unstable layer CAPE",
			"lightning potential",
			"10m wind",
			"80m wind",
			"10m wind gust",
			"skin temp",
			"2m temp",
			"2m potential temp",
			"2m temp - skin temp",
			"2m dew point",
			"2m RH",
			"precipitable water",
			"snow water equiv",
			"1h snowfall",
			"snow depth",
			"925mb temp",
			"850mb temp",
			"850mb wind",
			"850mb wind magnitude",
			"850 RH",
			"850-500mb mean RH",
			"RH with respect to PW",
			"700mb temp",
			"700mb vvel",
			"500mb temp",
			"500mb vort",
			"250mb wind",
			"250mb wind magnitude",
			"visibility",
			"cloud top height",
			"convective cloud top height",
			"ceiling",
			"echotop height",
			"VIL",
			"RADAR VIL",
			"total cloud cover",
			"low-level cloud cover",
			"mid-level cloud cover",
			"high-level cloud cover",
			"aviation flight rules",
			"fog",
			"downward long-wave radiation",
			"downward short-wave radiation",
			"ground heat flux",
			"latent heat flux",
			"sensible heat flux",
			"PBL height",
			"soil temp at 1cm",
			"soil temp at 4cm",
			"soil temp at 10cm",
			"soil moisture at sfc",
			"soil moisture at 1cm",
			"soil moisture at 4cm",
			"soil moisture at 10cm"
	]
}
