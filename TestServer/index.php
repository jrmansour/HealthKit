<?php 

session_start();

function generate_random_value( $variableName, $minVal, $maxVal, $delta, $precision )
{
   if (isset($_SESSION[$variableName])) {
       $oldVal = $_SESSION[$variableName];
       $multiplier = 1.0 / $precision; 
       // increment value by a random delta
       $newVal = $oldVal + (rand(0, 2*$delta * $multiplier) - $delta * $multiplier) / $multiplier;
       // fix the value if it goes out of range
       if ($newVal < $minVal) $newVal = $minVal;
       if ($newVal > $maxVal) $newVal = $maxVal;
       $_SESSION[$variableName] = $newVal;
   }  
   else {
       // set initial value
       $_SESSION[$variableName] = ($maxVal + $minVal) / 2.0;
   }
   return $_SESSION[$variableName];
};

$GSR = new stdClass();
$GSR->Con = generate_random_value('Con', 0, 0.8, 0.4, 0.01);
$GSR->Res = rand(0, 105);
$GSR->Vol= rand(0, 105);

$PO = new stdClass();
$PO->SPO2 = rand(0, 105);
$PO->BPM = rand(0, 105);

$sensors = new stdClass();
	
$sensors->Sensors = new stdClass();
$sensors->Sensors->GLC=rand(0, 105);
$sensors->Sensors->GSR= $GSR;
$sensors->Sensors->ECG=generate_random_value('ECG', 0, 5, 0.3, 0.01);
$sensors->Sensors->ACC=rand(0, 105);
$sensors->Sensors->AIR=generate_random_value('AIR', 300, 600, 50, 1);
$sensors->Sensors->EMG=rand(0, 105);
$sensors->Sensors->TMP=generate_random_value('TMP', 36, 39, 1, 0.5);
$sensors->Sensors->BP=rand(0, 105);
$sensors->Sensors->PO=$PO;
echo json_encode($sensors);
?>