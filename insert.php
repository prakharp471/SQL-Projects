<?php
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "airbnb";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
  die("Connection failed: " . $conn->connect_error);
}

$first_name = $_POST['first_name'];
$last_name  = $_POST['last_name'];
$email      = $_POST['email'];
$phone      = $_POST['phone'];

$sql = "INSERT INTO customer (first_name, last_name, email, phone)
        VALUES ('$first_name', '$last_name', '$email', '$phone')";

if ($conn->query($sql) === TRUE) {
  echo "Customer record added successfully!";
} else {
  echo "Error: " . $sql . "<br>" . $conn->error;
}

$conn->close();
?>