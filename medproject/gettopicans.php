<?php
// Display all errors for debugging purposes
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

require_once('db.php');

$response = array();
$stmt = null;

try {
    if ($_SERVER["REQUEST_METHOD"] === "GET") {
        if (isset($_GET['user_id']) && isset($_GET['subtopic_id']) && isset($_GET['date'])) {
            $user_id = htmlspecialchars($_GET['user_id']);
            $subtopic_id = htmlspecialchars($_GET['subtopic_id']);
            $date = htmlspecialchars($_GET['date']);

            error_log("Received parameters: user_id = $user_id, subtopic_id = $subtopic_id, date = $date");

            $sql = "SELECT ta.subtopic_id, ta.subtopic_name, ta.date, ta.user_id, vq.question_id, vq.question, 
                           ta.answer1, ta.answer2, ta.answer3, ta.answer4 
                    FROM topic_answer ta
                    JOIN video_questions vq ON ta.subtopic_id = vq.subtopic_id
                    WHERE ta.user_id = ? AND ta.subtopic_id = ? AND ta.date = ?";

            error_log("Executing SQL: $sql with params user_id = $user_id, subtopic_id = $subtopic_id, date = $date");

            $stmt = $conn->prepare($sql);

            if (!$stmt) {
                throw new Exception("Error in preparing SQL statement: " . $conn->error);
            }

            $stmt->bind_param("sss", $user_id, $subtopic_id, $date);

            if (!$stmt->execute()) {
                throw new Exception("Error in executing SQL statement: " . $stmt->error);
            }

            $result = $stmt->get_result();
            $data = $result->fetch_all(MYSQLI_ASSOC);

            error_log("Fetched raw data: " . print_r($data, true));

            if (count($data) > 0) {
                $formattedData = array();
                foreach ($data as $row) {
                    $answerKey = "answer" . $row['question_id'];
                    $formattedData[] = array(
                        'subtopic_id' => $row['subtopic_id'],
                        'subtopic_name' => $row['subtopic_name'],
                        'date' => $row['date'],
                        'user_id' => $row['user_id'],
                        'question_id' => $row['question_id'],
                        'question' => $row['question'],
                        'answer' => $row[$answerKey] ?? 'No answer',
                    );
                }
                $response['status'] = true;
                $response['data'] = $formattedData;
            } else {
                $response['status'] = false;
                $response['message'] = "No data found for the specified parameters";
            }
        } else {
            $response['status'] = false;
            $response['message'] = "Missing required parameters in the request";
        }
    } else {
        $response['status'] = false;
        $response['message'] = "Invalid request method. Only GET requests are allowed.";
    }
} catch (Exception $e) {
    $response['status'] = false;
    $response['message'] = "Error: " . $e->getMessage();
} finally {
    if ($stmt !== null) {
        $stmt->close();
    }
    $conn->close();
}

header('Content-Type: application/json');
echo json_encode($response);
?>
