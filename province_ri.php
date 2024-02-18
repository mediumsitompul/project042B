<?php


include "conn.php";



  if(isset($_REQUEST["pilihan0"])){
      $pilihan0 = $_REQUEST["pilihan0"];
  }else{
      $pilihan0 = "";
  }




  $json["datajs"] = array();
  $pilihan0 = mysqli_real_escape_string($connect, $pilihan0);
  $sql = "SELECT * FROM t_province_all WHERE current_use='1' order by province_name asc";
  $res = mysqli_query($connect, $sql);

  $numrows = mysqli_num_rows($res);
  if($numrows > 0){
     //check if there is any data
      while($array = mysqli_fetch_assoc($res)){
           array_push($json["datajs"], $array);
      }
  }else{
      $json["error"] = true;
      $json["errmsg"] = "No any data to show.";
  }

  mysqli_close($connect);

  header('Content-Type: application/json');
  // tell browser that its a json data
  echo json_encode($json);

?>
