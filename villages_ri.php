<?php

include "conn.php";

  //Parameter yang dikirim flutter... kok tdk tertangkap ya?
  if(isset($_REQUEST["pilihan3"])){  // $_REQUEST["pilihan1"] berasal dari kiriman Flutter main.dart saat dropdown
      $pilihan3 = $_REQUEST["pilihan3"];
  }else{
      //$pilihan3 ="1275120"; //medium, membuat dropdown3 terbuka
      $pilihan3 ="";
  }

  $json["datajs"] = array();
  $pilihan3 = mysqli_real_escape_string($connect, $pilihan3);
  $sql = "SELECT * FROM t_villages_all WHERE kecamatan_id = '$pilihan3'  AND current_use='1' ORDER BY villages_name ASC";
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
