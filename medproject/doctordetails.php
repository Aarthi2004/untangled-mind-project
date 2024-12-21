,<?php
// Include your database connection code here (e.g., db_conn.php)
//ji
error_reporting(E_ALL);
ini_set('display_errors', 1);
require_once('db.php');

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Check if user_id is provided, indicating a request for a single caretaker's data
$user_id = isset($_REQUEST['user_id']) ? $_REQUEST['user_id'] : null;


if ($user_id !== null) {
    // Fetch data for a single caretaker
    $stmt = $conn->prepare("SELECT user_id, Name, password, email_id, Age, Gender, phone_no, designation, institution, doctorimage FROM Doctor WHERE user_id = ?");
    
    if (!$stmt) {
        die("Prepare failed: " . $conn->error);
    }

    $stmt->bind_param("i", $user_id);
    $stmt->execute();

    $result = $stmt->get_result();

    if (!$result) {
        die("Query failed: " . $conn->error);
    }

    $doctorData = $result->fetch_assoc();

    // Check if data is found
    if ($doctorData) {
        // Encode image data
        $imagePath = $doctorData['doctorimage'];
        $imageData = file_get_contents($imagePath);
        $base64Image = base64_encode($imageData);
        $doctorData['doctorimage'] = $base64Image;

        echo json_encode(array('status' => 'success', 'data' => $doctorData));
    } else {
        echo json_encode(array('status' => 'error', 'message' => 'Doctor not found.'));
    }

    $stmt->close();
} else {
    // user_id is not provided
    echo json_encode(array('status' => 'error', 'message' => 'user_id is not provided.'));
}

$conn->close();
?>
