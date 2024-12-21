<?php
include 'db.php';
error_reporting(E_ALL);
ini_set('display_errors', 1);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Query to retrieve data from the "questions" table
$sql = "SELECT * FROM Questionaries";

$result = $conn->query($sql);

// Initialize an array to store the quiz questions and answers
$quizData = array();

// Check if there are results
if ($result->num_rows > 0) {
    
    // Fetch each row and add it to the quizData array
    while ($row = $result->fetch_assoc()) { 
        $states = "success";
        $data = array(
            "questions_no" => array(
                array(
                    "question" => $row["question"],
                    "answers" => array(
                        array("text" => $row["answer_1"]),
                        array("text" => $row["answer_2"]),
                        array("text" => $row["answer_3"]),
                        array("text" => $row["answer_4"]),
                        array("text" => $row["answer_5"]),
                    ),
                ),
            ),
        );

        // Add $data to $quizData
        $quizData[] = $data;
    }
}

// Create an associative array with the "questions" key and a "status" field
$response = [
    "status" => $states,
    "questions" => $quizData,
];

// Convert the response array to JSON
$jsonData = json_encode($response, JSON_PRETTY_PRINT);

// Output the JSON data
header("Content-Type: application/json");
echo $jsonData;

// Close the database connection
$conn->close();
?>
