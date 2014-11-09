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

$VALUE = new stdClass();
$VALUE->MPS = generate_random_value('MPS', 5, 55, 4, 0.4);
$VALUE->RPM = generate_random_value('RPM', 0, 50000, 1000, 1);
$VALUE->ML= generate_random_value('ML', 0, 100000, 0.4, 1);



$CAN = new stdClass();
$CAN->CAN=$VALUE;

echo json_encode($CAN);
?>