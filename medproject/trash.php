<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

require_once('db.php');

// Initialize status as false
$status = false;

// Check if the request is a POST request
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Get user ID, subtopic name, and individual questions and answers from POST data
    $userId = $_POST['user_id'];
    $subtopicName = $_POST['subtopic_name'];

    $question1 = $_POST['question1'];
    $answer1 = $_POST['answer1'];

    $question2 = $_POST['question2'];
    $answer2 = $_POST['answer2'];

    $question3 = $_POST['question3'];
    $answer3 = $_POST['answer3'];

    $question4 = $_POST['question4'];
    $answer4 = $_POST['answer4'];

    // Calculate scores for each answer
    $score1 = calculateScore($answer1);
    $score2 = calculateScore($answer2);
    $score3 = calculateScore($answer3);
    $score4 = calculateScore($answer4);

    // Calculate total score
    $totalScore = $score1 + $score2 + $score3 + $score4;

    // Calculate average score
    $total_score = $totalScore / 4;

    try {
        // Get current date
        $date = date('Y-m-d');

        // Check if the user has already submitted answers for the same subtopic on the same day
        $checkStmt = $conn->prepare("SELECT * FROM topic_answer WHERE user_id = ? AND subtopic_name = ? AND date = ?");
        $checkStmt->bind_param("iss", $userId, $subtopicName, $date);
        $checkStmt->execute();
        $result = $checkStmt->get_result();

        if ($result->num_rows > 0) {
            // User has already submitted answers, update the existing records
            $updateStmt = $conn->prepare("UPDATE topic_answer SET answer1 = ?, question1 = ?, answer2 = ?, question2 = ?, answer3 = ?, question3 = ?, answer4 = ?, question4 = ?, total_score = ? WHERE user_id = ? AND subtopic_name = ? AND date = ?");
            $updateStmt->bind_param("ssssssssddiss", $answer1, $question1, $answer2, $question2, $answer3, $question3, $answer4, $question4, $totalScore, $userId, $subtopicName, $date);
            $updateStmt->execute();
        } else {
            // User hasn't submitted answers for this subtopic on this day, insert new records
            $insertStmt = $conn->prepare("INSERT INTO topic_answer (user_id, date, subtopic_name, question1, answer1, question2, answer2, question3, answer3, question4, answer4, total_score) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
            $insertStmt->bind_param("isssssssssddd", $userId, $date, $subtopicName, $question1, $answer1, $question2, $answer2, $question3, $answer3, $question4, $answer4, $totalScore);

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

// Function to calculate score based on answer
function calculateScore($answer) {
    // Assign scores to each option
    switch ($answer) {
        case 'optiona':
            return 4;
        case 'optionb':
            return 3;
        case 'optionc':
            return 2;
        case 'optiond':
            return 1;
        default:
            return 0;
    }
}
?>
