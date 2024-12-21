<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

require_once('db.php');

// Initialize status as false
$status = false;

// Check if the request is a POST request
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Get user ID, answers, and subtopic name from form data
    $userId = $_POST['user_id'];
    $answers = $_POST['answers'];

    try {
        // Get current date
        $date = date('Y-m-d');

        // Prepare and execute SQL statement for insertion
        $insertStmt = $conn->prepare("INSERT INTO topic_answer (user_id, question_id, date, subtopic_name, answer) VALUES (?, ?, ?, ?, ?)");

        // Loop through the answers and insert each one
        foreach ($answers as $answer) {
            // Get current question ID, answer, and subtopic name
            $questionId = $answer['question_id'];
            $userAnswer = $answer['answer'];
            $subtopicName = $answer['subtopic_name'];

            // Bind parameters and execute for topic_answer table
            $insertStmt->bind_param("iisss", $userId, $questionId, $date, $subtopicName, $userAnswer);
            $insertStmt->execute();
        }

        // Set success message and update status
        $response['message'] = 'Answers submitted successfully';
        $status = true;
    } catch (PDOException $e) {
        // Set database error message in response
        $response['error'] = 'Database error: ' . $e->getMessage();
    }
} else {
    // Set method not allowed error message in response
    $response['error'] = 'Method Not Allowed';
}

// Include status in the response
$response['status'] = $status;

// Respond with the JSON-encoded response
echo json_encode($response);
?>
