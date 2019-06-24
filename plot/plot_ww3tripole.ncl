;************************************************
; These files are loaded by default in NCL V6.2.0 and newer
; load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
; load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl" 

  load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/cd_string.ncl"
;************************************************
begin
;************************************************
; read in netCDF file
;************************************************
  hemi="NH"
  ;hemi="SH"

  model = "ww3"
  ;model = "m6c5"
  ;model = "hycice5"

  if(model .eq. "hycice5")then
   rtsrc="/scratch3/NCEPDEV/stmp2/Denise.Worthen/CICE008/"
   nemsdir="/scratch4/NCEPDEV/ocean/save/Denise.Worthen/NEMS_INPUT0.1/cice_data/mx024/"
   ; load the grid file
   gf =addfile(nemsdir+"cice_grid_024.nc","r")
   rad2deg=180.d0/acos(-1.0d0)
   tlatname="tlat"
   tlonname="tlon"
   rfactor=rad2deg
   dirname=rtsrc+"history/"
   lon1=74.12
   lon2=-105.88
   lat1=60
   lat2=60
  end if

  if(model .eq. "m6c5")then
   ;rtsrc="/scratch3/NCEPDEV/stmp1/Denise.Worthen/rtgen.145717/tmp/cpld_fv3_mom6_cice_2d_atm_flux/"
   ;rtsrc="/scratch3/NCEPDEV/stmp1/Denise.Worthen/rtgen.21285/tmp/cpld_fv3_mom6_cice_35d_atm_flux/"
    rtsrc="/scratch3/NCEPDEV/stmp2/Jiande.Wang/rtgen.110388/tmp/cpld_fv3_mom6_cice_2d_atm_flux/"
   ; use one file for grid
   gf =addfile(rtsrc+"history/iceh_ic.2016-10-03-00000.nc","r")
   ;print(gf)
   tlatname="TLAT"
   tlonname="TLON"
   rfactor=1.0
   dirname=rtsrc+"history/"
   lon1=60.00
   lon2=-120.00
   lat1=60
   lat2=60
  end if

  if(model .eq. "ww3")then
   ;rtsrc="/scratch3/NCEPDEV/stmp1/Denise.Worthen/rtgen.145717/tmp/cpld_fv3_mom6_cice_2d_atm_flux/"
   ;rtsrc="/scratch3/NCEPDEV/stmp1/Denise.Worthen/rtgen.21285/tmp/cpld_fv3_mom6_cice_35d_atm_flux/"
   ;rtsrc="/scratch3/NCEPDEV/stmp2/Jiande.Wang/rtgen.110388/tmp/cpld_fv3_mom6_cice_2d_atm_flux/"
   ;rtsrc="/scratch3/NCEPDEV/stmp2/Jessica.Meixner/EMC_ww3_tri1/regtests/TriPolUpdate/work_serial/"
    rtsrc="/scratch3/NCEPDEV/stmp2/Jessica.Meixner/EMC_ww3_tripolar/regtests/TriPolUpdate/work_test2/"
   ; use one file for grid
   gf =addfile(rtsrc+"ww3.194801.nc","r")
   ;print(gf)
   tlatname="latitude"
   tlonname="longitude"
   rfactor=1.0
   dirname=rtsrc
   lon1=60.00
   lon2=-120.00
   lat1=60
   lat2=60
  end if


;************************************************
; ice
;************************************************

  ;lstep=1-1
   lstep=15-1

  cyear=1948
  cday=cyear+"-01-01-00000"
  print("day = "+cday)

  ; ice field
  varname="hs"
  levs=(/0.0,1.0,0.05/)

  if(model .eq. "hycice5")then
   icef =addfile(dirname+"iceh_24h."+cday+".nc","r")
  end if
  if(model .eq. "m6c5")then
   icef =addfile(dirname+"iceh_06h."+cday+".nc","r")
  end if
  if(model .eq. "ww3")then 
   icef =addfile(dirname+"ww3.194801.nc","r")
  end if
  print(icef)
  icevar=icef->$varname$(lstep,:,:)
  icevar@lon2d=gf->$tlonname$*rfactor
  icevar@lat2d=gf->$tlatname$*rfactor
  ;printVarSummary(icevar)
  icevar@units=""
  icevar@long_name=""

  ;       aivar = icef->hs(lstep,:,:)
  ; aivar@lon2d = gf->$tlonname$*rfactor
  ; aivar@lat2d = gf->$tlatname$*rfactor
  ; icemasked=icevar
  ; icemasked=mask(icevar, (aivar .eq. 0.0), False)
  ; icevar=icemasked

  ;times= icef->time

; Get the time units and set the first and last times that we want
  ;timeUnits = icef->time@units
  ;timeCalendar = icef->time@calendar

;************************************************
; add a poly line showing the polar seem along
; great circle path from (lon1,lat1) to (lon2,lat2)
;************************************************

;************************************************
; define the map
;************************************************
  ;wkstype="X11"
  wkstype="png"
  wkstype@wkWidth=800
  wkstype@wkHeight=800
  wks   = gsn_open_wks (wkstype,"ww3_tripole")              ; send graphics to X11 window

  ;gsn_define_colormap(wks,"MPL_Blues")
  ;gsn_reverse_colormap(wks)

  res                      = True        ; plot mods desired
  res@gsnDraw              = False       ; do not draw until the end
  res@gsnFrame             = False       ; do not automatically advance 'frame'

  ;res@cnFillMode = "MeshFill"
  res@cnFillMode = "RasterFill"
  ;res@mpFillOn   = True  ; this turns on the land
   res@mpFillOn   = False
  res@gsnStringFontHeightF = 0.05

  res@gsnPolar   =  hemi                         ; specify the hemisphere
  if(hemi .eq. "NH")then
   res@mpMinLatF    =  80                          ; minimum lat to plot
   res@mpCenterLonF = -45
  end if
  if(hemi .eq. "SH")then
   res@mpMaxLatF    = -50                            ; minimum lat to plot
   res@mpCenterLonF = 0.0
  end if


  res@cnFillDrawOrder   = "PreDraw"             ; draw contours first
  res@cnFillOn          = True                  ; color fill
  res@cnLinesOn         = False                 ; no contour lines
  res@cnLineLabelsOn    = False
  ;res@lbLabelBarOn      = True
  res@lbLabelBarOn      = False
  
  res@cnLevelSelectionMode = "ManualLevels"     ; set the contour levels with the following 3 resources
  res@cnMinLevelValF  = levs(0)                      ; set the minimum contour level
  res@cnMaxLevelValF  = levs(1)                      ; set the maximum contour level
  res@cnLevelSpacingF = levs(2)                      ; set the interval between contours

  res@cnFillPalette        = "MPL_rainbow"              ; choose colormap
  ;res@cnFillPalette        = "BlWhRe"              ; choose colormap
  ;res@cnFillPalette        = "BlueWhiteOrangeRed"              ; choose colormap
  ;res@cnFillPalette        = "NCV_roullet"              ; choose colormap
  ;res@cnFillPalette        = "WhBlGrYeRe"              ; choose colormap

  res@tiMainString = dirname+" "+cday
  ;res@tiMainString = compset+"  "+cday+"  "+varname
  res@tiMainFontHeightF = .01

  ;res@gsnCenterStringOrthogonalPosF = .15	    ; raise the CenterString slightly
  ;res@gsnStringFontHeightF = 0.01
  ;res@gsnCenterString = cd_string(times(lstep),"%d %F")

;************************************************
; Resources for the polyline
;************************************************

  res@mpGreatCircleLinesOn = True
  pres                  = True           ; polyline mods desired
  pres@gsLineThicknessF = 2.0            ; line thickness
  pres@gsLineColor      = "black"         ; color of lines
  pres@gsLineDashPattern =  1            ; dashes
  ;pres@tfPolyDrawOrder = "postDraw"

;************************************************
; resources for polymarkers
;************************************************

  mkres               = True
  ;mkres@gsMarkerIndex = 16         ; circle
  mkres@gsMarkerIndex = 15         ; open circle+cross
  ;mkres@gsMarkerIndex = 2         ; cross hair
  mkres@gsMarkerSizeF = 0.020
  mkres@gsMarkerColor = "Red"

;************************************************
;
;************************************************

  plot = gsn_csm_contour_map_polar(wks,icevar,res)    ; create the plot
  ;plot = gsn_csm_contour_map(wks,icevar,res)    ; create the plot
  ;this puts tripole line; dum= gsn_add_polyline(wks,plot,(/lon1, lon2/) , (/lat1, lat2/) ,pres)
  ;pum= gsn_add_polymarker(wks,plot,center_xlon,center_xlat,mkres)

  draw(plot)
  frame(wks)

exit

end
