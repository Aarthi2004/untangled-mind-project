<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

require_once('db.php');

// Initialize status as false
$status = false;

// Check if the request is a POST request
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Get user ID, subtopic ID, subtopic name, and individual questions and answers from POST data
    $userId = $_POST['user_id'];
    $subtopicId = $_POST['subtopic_id'];
    $subtopicName = $_POST['subtopic_name'];

    $question1 = $_POST['question1'];
    $answer1 = $_POST['answer1'];

    $question2 = $_POST['question2'];
    $answer2 = $_POST['answer2'];

    $question3 = $_POST['question3'];
    $answer3 = $_POST['answer3'];

    $question4 = $_POST['question4'];
    $answer4 = $_POST['answer4'];

    try {
        // Get current date
        $date = date('Y-m-d');

        // Check if the user has already submitted answers for the same subtopic on the same day
        $checkStmt = $conn->prepare("SELECT * FROM topic_answer WHERE user_id = ? AND subtopic_name = ? AND date = ?");
        $checkStmt->bind_param("sss", $userId, $subtopicName, $date);
        $checkStmt->execute();
        $result = $checkStmt->get_result();

        if ($result->num_rows > 0) {
            // User has already submitted answers, update the existing records
            $updateStmt = $conn->prepare("UPDATE topic_answer SET answer1 = ?, question1 = ?, answer2 = ?, question2 = ?, answer3 = ?, question3 = ?, answer4 = ?, question4 = ? WHERE user_id = ? AND subtopic_id = ? AND date = ?");
            $updateStmt->bind_param("sssssssssss", $answer1, $question1, $answer2, $question2, $answer3, $question3, $answer4, $question4, $userId, $subtopicId, $date);
            $updateStmt->execute();
        } else {
            // User hasn't submitted answers for this subtopic on this day, insert new records
            $insertStmt = $conn->prepare("INSERT INTO topic_answer (user_id, date, subtopic_id, subtopic_name, question1, answer1, question2, answer2, question3, answer3, question4, answer4) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
            $insertStmt->bind_param("ssssssssssss", $userId, $date, $subtopicId, $subtopicName, $question1, $answer1, $question2, $answer2, $question3, $answer3, $question4, $answer4);
            $insertStmt->execute();
        }

        // Set success message and update status
        $response['message'] = 'Answers submitted successfully';
        $status = true;
    } catch (Exception $e) {
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
header('Content-Type: application/json');
echo json_encode($response);
?>