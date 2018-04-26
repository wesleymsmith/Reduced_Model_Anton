proc draw_box_minmax {sel_minmax} {
 set min_x [lindex [lindex $sel_minmax 0] 0]
 set max_x [lindex [lindex $sel_minmax 1] 0]
 set min_y [lindex [lindex $sel_minmax 0] 1]
 set max_y [lindex [lindex $sel_minmax 1] 1]
 set min_z [lindex [lindex $sel_minmax 0] 2]
 set max_z [lindex [lindex $sel_minmax 1] 2]
 
 draw materials off
 draw color yellow
 
 draw line "$min_x $min_y $min_z" "$max_x $min_y $min_z"
 draw line "$min_x $min_y $min_z" "$min_x $max_y $min_z"
 draw line "$min_x $min_y $min_z" "$min_x $min_y $max_z"
 
 draw line "$max_x $min_y $min_z" "$max_x $max_y $min_z"
 draw line "$max_x $min_y $min_z" "$max_x $min_y $max_z"
 
 draw line "$min_x $max_y $min_z" "$max_x $max_y $min_z"
 draw line "$min_x $max_y $min_z" "$min_x $max_y $max_z"
 
 draw line "$min_x $min_y $max_z" "$max_x $min_y $max_z"
 draw line "$min_x $min_y $max_z" "$min_x $max_y $max_z"
 
 draw line "$max_x $max_y $max_z" "$min_x $max_y $max_z"
 draw line "$max_x $max_y $max_z" "$max_x $min_y $max_z"
 draw line "$max_x $max_y $max_z" "$max_x $max_y $min_z"

}
proc draw_minmax {sel} {
 set sel_minmax [measure minmax $sel]
 set min_x [lindex [lindex $sel_minmax 0] 0]
 set max_x [lindex [lindex $sel_minmax 1] 0]
 set min_y [lindex [lindex $sel_minmax 0] 1]
 set max_y [lindex [lindex $sel_minmax 1] 1]
 set min_z [lindex [lindex $sel_minmax 0] 2]
 set max_z [lindex [lindex $sel_minmax 1] 2]
 
 draw materials off
 draw color yellow
 
 draw line "$min_x $min_y $min_z" "$max_x $min_y $min_z"
 draw line "$min_x $min_y $min_z" "$min_x $max_y $min_z"
 draw line "$min_x $min_y $min_z" "$min_x $min_y $max_z"
 
 draw line "$max_x $min_y $min_z" "$max_x $max_y $min_z"
 draw line "$max_x $min_y $min_z" "$max_x $min_y $max_z"
 
 draw line "$min_x $max_y $min_z" "$max_x $max_y $min_z"
 draw line "$min_x $max_y $min_z" "$min_x $max_y $max_z"
 
 draw line "$min_x $min_y $max_z" "$max_x $min_y $max_z"
 draw line "$min_x $min_y $max_z" "$min_x $max_y $max_z"
 
 draw line "$max_x $max_y $max_z" "$min_x $max_y $max_z"
 draw line "$max_x $max_y $max_z" "$max_x $min_y $max_z"
 draw line "$max_x $max_y $max_z" "$max_x $max_y $min_z"
}

proc draw_bounding_sphere {sel} {
 set sel_minmax [measure minmax $sel]
 set sel_boxdiag [vecsub [lindex $sel_minmax 1] [lindex $sel_minmax 0]]
 set sel_radius [expr [veclength $sel_boxdiag] / 2]
 set sel_center [measure center $sel]
 
 draw materials on
 draw material "Transparent"
 draw sphere $sel_center radius $sel_radius
}

#returns a random unit vector
proc vecrand {} {
 vecnorm "[expr rand() * 2 - 1] [expr rand() * 2 - 1] [expr rand() * 2 - 1]"
} 

#produce a random rotation matrix
proc transrand {} {
 set xmat [transaxis x [expr rand() * 360 - 180]]
 set ymat [transaxis y [expr rand() * 360 - 180]]
 set zmat [transaxis z [expr rand() * 360 - 180]]

 transmult $xmat $ymat $zmat
}

proc clamp {{x} {xmin} {xmax}} {
 expr max($xmin,[expr min($x,$xmax)])
}

#check collision of 2 boxes as defined by a pair of
#minmaxes
proc check_collision_box_box {{minmax0} {minmax1}} {
 #assumes collision at start and will get set to no
 #collision if box intervals fail to overlap along any
 #given dimension
 set testval 1
 foreach bdim {0 1 2} {
	set min0 [lindex [lindex $minmax0 0] $bdim]
	set max0 [lindex [lindex $minmax0 1] $bdim]
	set min1 [lindex [lindex $minmax1 0] $bdim]
	set max1 [lindex [lindex $minmax1 1] $bdim]
	
	#test if boxes overlap along this dimension
	set temptest [expr [expr $min0 <= $max1] * [expr $max0 >= $min1]]
	set testval [expr $testval * $temptest]
 }
 return $testval
}

#check for collision of a sphere and a box where
#sphere is defined as a center vector and radius
#and box is defined with a minmax
proc check_collision_sphere_box {{sphere_center} {sphere_radius} {minmax}} {
 set min_x [lindex [lindex $minmax 0] 0]
 set max_x [lindex [lindex $minmax 1] 0]
 set min_y [lindex [lindex $minmax 0] 1]
 set max_y [lindex [lindex $minmax 1] 1]
 set min_z [lindex [lindex $minmax 0] 2]
 set max_z [lindex [lindex $minmax 1] 2]

 set b_x [clamp [lindex $sphere_center 0] $min_x $max_x]
 set b_y [clamp [lindex $sphere_center 1] $min_y $max_y]
 set b_z [clamp [lindex $sphere_center 2] $min_z $max_z]

 set d_sq_x [expr [expr $b_x - [lindex $sphere_center 0]] ** 2]
 set d_sq_y [expr [expr $b_y - [lindex $sphere_center 1]] ** 2]
 set d_sq_z [expr [expr $b_z - [lindex $sphere_center 2]] ** 2]

 set d_b_s [expr sqrt([expr $d_sq_x + $d_sq_y + $d_sq_z])]
 
 expr $d_b_s <= $sphere_radius
}

#check for collision of two spheres where each
#one is represented as a center and a radius
proc check_collision_sphere_sphere {{sphere_center0} {sphere_radius0} {sphere_center1} {sphere_radius1}} {
 set d_0_1 [veclength [vecsub $sphere_center1 $sphere_center0]]
 expr $d_0_1 <= [expr $sphere_radius0 + $sphere_radius1]
}

#Convenience wrappers for above collision checking procs using atom selections
#additional padding can be specified as well but defaults to 0

#check for collision between two selections treating both
#selections as bounding boxes
proc check_mol_collision_box_box {{box_sel0} {box_sel1} {box_pad0 0} {box_pad1 0}} {
 set minmax0 [measure minmax $box_sel0]
 set minmax1 [measure minmax $box_sel1]

 set boxmin0 [vecsub [lindex $minmax0 0] "$box_pad0 $box_pad0 $box_pad0"]
 set boxmax0 [vecadd [lindex $minmax0 1] "$box_pad0 $box_pad0 $box_pad0"]
 set boxmin1 [vecsub [lindex $minmax1 0] "$box_pad1 $box_pad1 $box_pad1"]
 set boxmax1 [vecadd [lindex $minmax1 1] "$box_pad1 $box_pad1 $box_pad1"]

 set boxminmax0 "{$boxmin0} {$boxmax0}"
 set boxminmax1 "{$boxmin1} {$boxmax1}"

 #debug printing statements
 #puts "minmax0: $minmax0"
 #puts "minmax1: $minmax1"
 #puts "box_pad0: $box_pad0"
 #puts "box_pad1: $box_pad1"
 #puts "boxmin0: $boxmin0"
 #puts "boxmax0: $boxmax0"
 #puts "boxmin1: $boxmin1"
 #puts "boxmax1: $boxmax1"
 #puts "boxminmax0: $boxminmax0"
 #puts "boxminmax1: $boxminmax1"

 check_collision_box_box $boxminmax0 $boxminmax1
}

#check for collision between two selections treating the
#first selection as a bounding sphere and the second selection
#as a bounding box
proc check_mol_collision_sphere_box {{sphere_sel} {box_sel} {sphere_pad 0} {box_pad 0}} {
 set sphere_inner_minmax [measure minmax $sphere_sel]
 set sphere_center [measure center $sphere_sel]
 set sphere_diag_vec [vecsub [lindex $sphere_inner_minmax 1] [lindex $sphere_inner_minmax 0]]
 set sphere_radius [expr [veclength $sphere_diag_vec] / 2 + $sphere_pad]
 
 set box_sel_minmax [measure minmax $box_sel]
 set box_min [vecsub [lindex $box_sel_minmax 0] "$box_pad $box_pad $box_pad"]
 set box_max [vecadd [lindex $box_sel_minmax 1] "$box_pad $box_pad $box_pad"]
 set box_minmax "{$box_min} {$box_max}"

 check_collision_sphere_box $sphere_center $sphere_radius $box_minmax
}

proc get_sel_diag_sphere_r {{sel}} {
	set sphere_inner_minmax [measure minmax $sel]
	set sphere_center [measure center $sel]
	set sphere_diag_vec [vecsub [lindex $sphere_inner_minmax 1] [lindex $sphere_inner_minmax 0]]
	set sphere_radius [expr [veclength $sphere_diag_vec] / 2]
	return $sphere_radius
}
#check for collision between two selections treating both
#selections as bounding spheres
proc check_mol_collision_sphere_sphere {{sphere_sel0} {sphere_sel1} {sphere_pad0 0} {sphere_pad1 0}} {
 set sphere_center0 [measure center $sphere_sel0]
 set sphere_radius0 [expr get_sel_diag_sphere_r + $sphere_pad0]

 set sphere_center1 [measure center $sphere_sel1]
 set sphere_radius1 [expr get_sel_diag_sphere_r + $sphere_pad1]
 
 check_collision_sphere_sphere $sphere_center0 $sphere_radius0 $sphere_center1 $sphere_radius1
}

#calculates the minimum 'signed' distance between atoms in a selection
#and a given sphere. Distance is positive for atoms outside the sphere
#and negative for atoms inside
proc get_sel_to_sphere_min_signed_dist {{sel} {sphere_c {0 0 0}} {sphere_r 1.0} {guess 100}} {
	set sel_coords [$sel get "x y z"]
	set minDist $guess
	foreach sel_crd $sel_coords {
		set minDist [expr min($minDist,[expr [veclength [vecsub $sel_crd $sphere_c]] - $sphere_r])]
	}
	
	return $minDist
}
proc check_mol_collision_sphere_sel {{sphere_sel} {sel} {distCut 0}} {
	set sphere_c [measure center $sphere_sel]
	set sphere_r [get_sel_diag_sphere_r $sphere_sel]

	set minDist [get_sel_to_sphere_min_signed_dist $sel $sphere_c $sphere_r [expr $distCut * 100]]

	set collided [expr $minDist < $distCut]
	return $collided
}

#this is an N x M process eg time scales as the product of the atoms in
#sel0 (M) times the atoms in sel1 (N). This can become very slow for
#large selections so use with caution
proc check_mol_collision_sel_dist {{sel0} {sel1} {distCut .5}} {
	set minDist [get_sel_sel_minDist $sel0 $sel1 [expr $distCut * 100]]
	set collided [expr $minDist < $distCut]
	return $collided
}
proc get_sel_sel_minDist {{sel0} {sel1} {guess 1000}} {
	set sel0_coords [$sel0 get "x y z"]
	set sel1_coords [$sel1 get "x y z"]
	set minDist [expr $distCut * 100] 
	foreach sel0_crd $sel0_coords {
		foreach sel1_crd $sel1_coords {
			set minDist [expr min($minDist,[veclength [vecsub $sel0_crd $sel1_crd]])]
		}
	}
	return $minDist
}

#find the radius of the smallest sphere which contains all atoms in an atom selection
proc get_sel_minSphere_r {sel} {
	set sel_len [llength [$sel get index]]
	set sel_center [measure center $sel]
	set sel_coords [$sel get "x y z"]
	set maxDist 0
	foreach selCrd $sel_coords {
		set maxDist [expr max($maxDist,[veclength [vecsub $sel_center $selCrd]])]
	}
	return $maxDist
}

proc check_mol_collision_minSphere_minSphere {{sel0} {sel1} {pad0 0} {pad1 0}} {
	set sel0_r [expr [get_sel_minSphere_r $sel0] + $pad0]
	set sel0_c [measure center $sel0]

	set sel1_r [expr [get_sel_minSphere_r $sel1] + $pad1]
	set sel1_c [measure center $sel1]

	check_collision_sphere_sphere $sel0_c $sel0_r $sel1_c $sel1_r
}

proc check_mol_collision_minSphere_sel {{sphere_sel} {sel} {distCut 0}} {
	set sphere_c [measure center $sphere_sel]
	set sphere_r [get_sel_minSphere_r $sphere_sel]

	set minDist [get_sel_to_sphere_min_signed_dist $sel $sphere_c $sphere_r [expr $distCut * 100]]

	set collided [expr $minDist < $distCut]
	return $collided
}

proc padded_sel_bounds {{sel} {pad_all 0} {pad_vec {0 0 0}} {pad_bvec {{0 0 0} {0 0 0}}}} {
 set pad_x [lindex $pad_vec 0]
 set pad_y [lindex $pad_vec 1]
 set pad_z [lindex $pad_vec 2]

 set pad_lvec [lindex $pad_bvec 0]
 set pad_uvec [lindex $pad_bvec 1] 

 set padvec "[expr $pad_all + $pad_x] [expr $pad_all + $pad_y] [expr $pad_all + $pad_z]"

 set sel_minmax [measure minmax $sel]
 set sel_min [vecsub [lindex $sel_minmax 0] [vecadd $padvec $pad_lvec]]
 set sel_max [vecadd [lindex $sel_minmax 1] [vecadd $padvec $pad_uvec]]

 return "{$sel_min} {$sel_max}"
}

proc rand_point_in_box {bounding_minmax} {
 set minmax_range [vecsub [lindex $bounding_minmax 1] [lindex $bounding_minmax 0]]
 set x_range [lindex $minmax_range 0]
 set y_range [lindex $minmax_range 1]
 set z_range [lindex $minmax_range 2]
 set min_vec [lindex $bounding_minmax 0] 

 set delta_vec "[expr rand() * $x_range] [expr rand() * $y_range] [expr rand() * $z_range]"

 return [vecadd $min_vec $delta_vec] 
}

proc rand_point_in_sphere {{c {0.0 0.0 0.0}} {r 1.0}} {
 set PI 3.14159265358979323846
 set rand_r "[expr rand() * $r]"
 set rand_theta "[expr rand() * 2 * $PI]"
 set rand_phi "[expr rand() * $PI]"
 set z_crd "[expr $rand_r * cos($rand_phi)]"
 set y_crd "[expr $rand_r * sin($rand_phi) * sin($rand_theta)]"
 set x_crd "[expr $rand_r * sin($rand_phi) * cos($rand_theta)]"

 return "$x_crd $y_crd $z_crd"
}

proc check_sel_collisions {{sel} {collider_sel_list {}} {colliderProc "check_mol_collision_sphere_box"}} {
 set collided 0
 foreach csel $collider_sel_list {
	set collided [expr $collided + [$colliderProc $sel $csel]]
 }
 set collided [expr $collided > 0]
 return $collided
}

proc sel_random_move {{sel} {bounding_minmax {{0 0 0} {0 0 0}}} {collider_sel_list {}} {colliderProc "check_mol_collision_sphere_box"} {rotate 1}} {
 puts "bounding min_max: $bounding_minmax" 
 puts "starting center: [measure center $sel]"

 set new_center [rand_point_in_sphere $c $r]
 puts "proposed new center: $new_center"

 set move_vec [vecsub $new_center [measure center $sel]]
 puts "-needed move vector: $move_vec"

 draw delete all

 draw_bounding_sphere $sel
 draw_box_minmax $bounding_minmax
 foreach csel $collider_sel_list {
 	draw_minmax $csel
 }

 $sel moveby $move_vec
 while {[expr [check_sel_collisions $sel $collider_sel_list $colliderProc] > 0]} {
	puts "--collision detected, trying new center--"
	puts "current bad center: [measure minmax $sel]"
 	set new_center [rand_point_in_sphere $c $r]
	puts "propsed new center: $new_center"
	set move_vec [vecsub $new_center [measure center $sel]]
	puts "-required move vector: $move_vec"
	$sel moveby $move_vec
    draw delete all
	draw_box_minmax $bounding_minmax
	draw_bounding_sphere $sel
 	foreach csel $collider_sel_list {
 		draw_minmax $csel
 	}
 }

 if {$rotate > 0} {
	puts "computing new random orientation"
	set current_center [measure center $sel]
	set rotmat [transrand]
	puts "rotation matrix: $rotmat"
	$sel move $rotmat
    set move_vec [vecsub $current_center [measure center $sel]]
    $sel moveby $move_vec
	draw delete all
	draw_bounding_sphere $sel
 	foreach csel $collider_sel_list {
 		draw_minmax $csel
 	}
 }
}

proc sel_random_sphere_move {{sel} {c {0 0 0}} {r {1}} {collider_sel_list {}} {colliderProc "check_mol_collision_sphere_sphere"} {rotate 1}} {
 puts "bounding min_max: $bounding_minmax" 
 puts "starting center: [measure center $sel]"

 set new_center [rand_point_in_box $bounding_minmax]
 puts "proposed new center: $new_center"

 set move_vec [vecsub $new_center [measure center $sel]]
 puts "-needed move vector: $move_vec"

 draw delete all

 draw_bounding_sphere $sel
 draw_box_minmax $bounding_minmax
 foreach csel $collider_sel_list {
 	draw_minmax $csel
 }

 $sel moveby $move_vec
 while {[expr [check_sel_collisions $sel $collider_sel_list $colliderProc] > 0]} {
	puts "--collision detected, trying new center--"
	puts "current bad center: [measure minmax $sel]"
 	set new_center [rand_point_in_box $bounding_minmax]
	puts "propsed new center: $new_center"
	set move_vec [vecsub $new_center [measure center $sel]]
	puts "-required move vector: $move_vec"
	$sel moveby $move_vec
    draw delete all
	draw_box_minmax $bounding_minmax
	draw_bounding_sphere $sel
 	foreach csel $collider_sel_list {
 		draw_minmax $csel
 	}
 }

 if {$rotate > 0} {
	puts "computing new random orientation"
	set current_center [measure center $sel]
	set rotmat [transrand]
	puts "rotation matrix: $rotmat"
	$sel move $rotmat
    set move_vec [vecsub $current_center [measure center $sel]]
    $sel moveby $move_vec
	draw delete all
	draw_bounding_sphere $sel
 	foreach csel $collider_sel_list {
 		draw_minmax $csel
 	}
 }
}


proc move_sel_into_system {{sel} {colliders_mol_id "top"} \
	{colliders_sel_list {}} {colliderProc "check_mol_collision_sphere_box"} {rotate 1} \
	{pad_val 0} {pad_vec {0 0 0}} {pad_bvec {{0 0 0} {0 0 0}}} } {
 set isel 0
 foreach csel $colliders_sel_list {
	set csel_text [$csel text]
	if {$isel == 0} {
		set sys_sel_text "($csel_text)"
	} else {
		set sys_sel_text "$sys_sel_text or ($csel_text)"
	}
	set isel [expr $isel + 1]
 }
 set sys_sel_text "\"$sys_sel_text\""

 puts "combined collider system selection text: $sys_sel_text"
 puts "-selection command: \[atomselect $colliders_mol_id $sys_sel_text\]"
 set sys_sel [atomselect $colliders_mol_id "$sys_sel_text"]
 

 puts "system minmax: [measure minmax $sys_sel]"
 set sys_bounds [padded_sel_bounds $sys_sel $pad_val $pad_vec $pad_bvec]
 puts "system bounds: $sys_bounds"

 sel_random_move $sel $sys_bounds $colliders_sel_list $colliderProc $rotate

}

### ### ###
#EXAMPLE - load piezo protein model and add 20 yoda
#          molecules to the region of space 20 Angstroms
#          above or below the protein (z axis)
###
### Assumes you have cd'd to directory containing files:
# - prot_only_reduced.pdb
# - yoda.geomOpt.pdb
# - vmd_drawing_scripts.tcl
### ###
### In VMD tk console
# source vmd_drawing_scripts.tcl
# set protFileName "prot_only_reduced.pdb"
# mol new $protFileName
# set prot_sel [atomselect top "protein"]
# set ligFileName "yoda.geomOpt.pdb"
# mol new $ligFileName
# set outFileBase "yoda_mol"
# set outFileExt "pdb"
# set lig_sel [atomselect top "all"]
# set csel [list $prot_sel]
# set padVec {0 0 20}
# set prot_bounds [padded_sel_bounds $prot_sel 0 $padVec]
# sel_random_move $lig_sel $prot_bounds $csel
# set i 0
# set outFileName "${outFileBase}_${i}.${outFileExt}"
# $lig_sel writepdb $outFileName
# for {set i 1} {$i < 20} {incr i} {
#	mol new $ligFileName
# 	lappend csel $lig_sel
#	set lig_sel [atomselect top "all"]
#	sel_random_move $lig_sel $prot_bounds $csel
#	set outFileName "${outFileBase}_${i}.${outFileExt}"
#	$lig_sel writepdb $outFileName
# }
### ### ###