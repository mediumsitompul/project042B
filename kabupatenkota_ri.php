<?php

include "conn.php";



  if(isset($_REQUEST["pilihan1"])){  // $_REQUEST["pilihan1"] berasal dari kiriman Flutter main.dart saat dropdown
      $pilihan1 = $_REQUEST["pilihan1"];
  }else{
      $pilihan1 ="";
  }

  $json["datajs"] = array();
  $pilihan1 = mysqli_real_escape_string($connect, $pilihan1);
  $sql = "SELECT * FROM t_kabupatenkota_all WHERE province_id = '$pilihan1' AND current_use='1' ORDER BY province_id ASC";

  
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
