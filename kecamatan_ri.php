<?php

include "conn.php";


 
 // data ini tidak ter-receive dari flutter???
 //$pilihan2 ="1275";
 //$pilihan2 = $_REQUEST["pilihan2"];
 
  //Parameter yang dikirim flutter... kok tdk tertangkap ya?
  if(isset($_REQUEST["pilihan2"])){  // $_REQUEST["pilihan1"] berasal dari kiriman Flutter main.dart saat dropdown
      $pilihan2 = $_REQUEST["pilihan2"];
  }else{
      //$pilihan2 ="1275"; //medium, membuat dropdown3 terbuka
      $pilihan2 ="";
  }

  $json["datajs"] = array();
  $pilihan2 = mysqli_real_escape_string($connect, $pilihan2);
  $sql = "SELECT * FROM t_kecamatan_all WHERE regency_id = '$pilihan2' AND current_use='1' ORDER BY regency_id ASC";
  $res = mysqli_query($connect, $sql);

  $numrows = mysqli_num_rows($res);
  if($numrows > 0){
      while($array = mysqli_fetch_assoc($res)){
          array_push($json["datajs"], $array);
      }
  }else{

      $json["error"] = true;
      $json["errmsg"] = "No any data to show.";
  }

  mysqli_close($connect);
  header('Content-Type: application/json');
  echo json_encode($json);

?>
