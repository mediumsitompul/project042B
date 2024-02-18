<?php
	include "conn.php";
	$timezone = "Asia/Jakarta";
	if(function_exists('date_default_timezone_set'))
	date_default_timezone_set($timezone);

	$tps_id= $_POST['tps_id'];
	$alamat= $_POST['alamat'];
	$province= $_POST['province'];
	$kabupatenkota= $_POST['kabupatenkota'];
	$kecamatan= $_POST['kecamatan'];
	$kelurahan= $_POST['kelurahan'];
	$suara_caleg1 = $_POST['suara_caleg1'];
	$username_entry= $_POST['username_entry'];
	$name_entry= $_POST['name_entry'];
	$description= $_POST['description'];
	
	$image= $_FILES['image']['name'];
	$imagePath="uploads/".$image;
?>

<?php
if($tps_id != NULL AND $suara_caleg1 != NULL AND $province != NULL AND $kabupatenkota != NULL 
AND $kecamatan != NULL AND $kelurahan != NULL AND $imagePath != NULL) {


        $aSQL = "
		SELECT * from t_qc
		where tps_id='$tps_id' AND province ='$province' AND $kabupatenkota='$kabupatenkota' 
		AND kecamatan ='$kecamatan' AND $kelurahan='$kelurahan'
		";
		$aQResult=mysqli_query($connect, $aSQL);
        while ($aRow = mysqli_fetch_array($aQResult))
        {
        $id_= $aRow["id"];
        }
	?>

	<?php
		if($id_ == NULL) {
		
		$image_link = "https://mediumsitompul.com/qcri/uploads/"."$image";
		
		move_uploaded_file($_FILES['image']['tmp_name'],$imagePath);
		$connect -> query("
		INSERT INTO t_qc (
		tps_id,
		alamat,
		province,
		kabupatenkota,
		kecamatan,
		kelurahan,
		suara_caleg1,
		username_entry,
		name_entry,
		datetime_entry,
		description,
		image)

		VALUES (
		'".$tps_id."',
		'".$alamat."',
		'".$province."',
		'".$kabupatenkota."',
		'".$kecamatan."',
		'".$kelurahan."',
		'".$suara_caleg1."',
		'".$username_entry."',
		'".$name_entry."',
		'".date("Y-m-d H:i:s")."',
		'".$description."',
		'".$image_link."'
		)
		");
        echo json_encode('success');
        }else


        echo json_encode('failed');
        }
//         else{
// 	echo json_encode('success3');//NEW MEDIUM
//      }

?>
