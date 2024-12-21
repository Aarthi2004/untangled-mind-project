<?php
include 'db.php';
error_reporting(E_ALL);
ini_set('display_errors', 1);

// Check if the form is submitted
if ($_SERVER["REQUEST_METHOD"] == "POST") {

    // Check if 'user_id' and 'user_answers' keys are set
    if (isset($_POST['user_id'])) {
        $userId = $_POST['user_id'];

        // Fetch all question IDs from the 'qns' table
        $questionQuery = "SELECT question_id FROM qns";
        $questionResult = $conn->query($questionQuery);
        $questions = [];
        while ($row = $questionResult->fetch_assoc()) {
            $questions[] = $row['question_id'];
        }

        // Validate 'user_answers' format
        if (isset($_POST['user_answers'])) {
            $userAnswers = json_decode($_POST['user_answers'], true);

            if (is_array($userAnswers)) {
                // Validate if all questions exist in the 'qns' table
                $missingQuestions = array_diff($userAnswers, $questions);

                if (empty($missingQuestions)) {
                    // Retrieve the maximum day for the given user and date
                    $date = date('Y-m-d');
                    $dayQuery = "SELECT MAX(day) as max_day FROM user_responses WHERE user_id = '$userId' AND day = '$date'";
                    $dayResult = $conn->query($dayQuery);
                    $dayRow = $dayResult->fetch_assoc();

                    if ($dayRow['max_day'] !== null) {
                        // If there is existing data for the given user and date, increment the day
                        $dayNumber = (int) $dayRow['max_day'] + 1;
                    } else {
                        // If no existing data for the given user and date, set the day to 1
                        $dayNumber = 1;
                    }

                    // Insert user answers for all questions into the 'answers' table
                    $values = [];
                    foreach ($userAnswers as $userAnswer) {
                        $values[] = "('$userId', '$userAnswer', '$dayNumber', '$date')";
                    }
                    $sqlInsert = "INSERT INTO answers (user_id, user_answer, day, date) VALUES " . implode(', ', $values);

                    if ($conn->query($sqlInsert) === TRUE) {
                        // Successful insertion
                        $response = array('status' => 'success', 'message' => 'User Answers Updated');
                        echo json_encode($response);
                    } else {
                        // Error in database insertion
                        $response = array('status' => 'error', 'message' => 'Error: ' . $conn->error);
                        echo json_encode($response);
                    }
                } else {
                    // Some questions are missing in the 'qns' table
                    $response = array('status' => 'error', 'message' => 'Questions not found in the qns table.');
                    echo json_encode($response);
                }
            } else {
                // Invalid format for 'user_answers'
                $response = array('status' => 'error', 'message' => 'Invalid format for user_answers.');
                echo json_encode($response);
            }
        } else {
            // Missing 'user_answers' parameter
            $response = array('status' => 'error', 'message' => 'Missing user_answers parameter.');
            echo json_encode($response);
        }
    } else {
        // Missing 'user_id' parameter
        $response = array('status' => 'error', 'message' => 'Missing user_id parameter.');
        echo json_encode($response);
    }
} else {
    // Handle non-POST requests (e.g., return an error response)
    $response = array('status' => 'error', 'message' => 'Invalid request method.');
    echo json_encode($response);
}

// Close the database connection
$conn->close();
?>
