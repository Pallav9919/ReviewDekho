<?php
use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;


header('Access-Control-Allow-Origin: *');
header("Access-Control-Allow-Methods: HEAD, GET, POST, PUT, PATCH, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: X-API-KEY, Origin, X-Requested-With, Content-Type, Accept, Access-Control-Request-Method,Access-Control-Request-Headers, Authorization");
header('Content-Type: application/json');
$method = $_SERVER['REQUEST_METHOD'];
if ($method == "OPTIONS") {
header('Access-Control-Allow-Origin: *');
header("Access-Control-Allow-Headers: X-API-KEY, Origin, X-Requested-With, Content-Type, Accept, Access-Control-Request-Method,Access-Control-Request-Headers, Authorization");
header("HTTP/1.1 200 OK");
die();
}

require 'vendor/autoload.php';
require 'db.php';

$app = new \Slim\App;

$app->post('/Register',function(Request $request,Response $response,$arg){
    $_input = $request->getParsedBody();
    $userid = $_input['userid'];
    $firstname = $_input['fname'];
    $lastname = $_input['lname'];
    $emailid = $_input['email'];
    $city = $_input['city'];
    $password = $_input['password'];
    $sql = "SELECT * FROM userdetails WHERE userid='".$userid."'";

    $db = new db();
    $db = $db->connect();
    $stmt = $db->query($sql);
    $result = $stmt->fetchAll(PDO::FETCH_OBJ);
    if($result!=null){
        echo json_encode("Already Registered");
    }
    else{
        $sql = "INSERT INTO userdetails(Userid,Password,First_name,Last_name,Email_id,City) VALUES (:userid,:password,:fname,:lname,:email,:city)";
        $stmt = $db->prepare($sql);
        $stmt->bindParam(':userid',$userid);
        $stmt->bindParam(':password',$password);
        $stmt->bindParam(':fname',$firstname);
        $stmt->bindParam(':lname',$lastname);
        $stmt->bindParam(':email',$emailid);
        $stmt->bindParam(':city',$city);
        $stmt->execute();
        echo json_encode("Registered Successfully");
    }
    $db = null;
});

$app->post('/Login',function(Request $request,Response $response,$arg){
    

    $_input = $request->getParsedBody();
    $userid = $_input['userid'];
    $password = $_input['password'];
    $db = new db();
    $db = $db->connect();
    $sql = "SELECT * FROM userdetails WHERE Userid='".$userid."' AND Password='".$password."'" ;
    $stmt = $db->query($sql);
    $result = $stmt->fetchAll(PDO::FETCH_OBJ);

    if($result!=null){
        echo json_encode("Login Successfull");
    }
    else{
        echo json_encode("Wrong Userid or Password");
    }
});

$app->post('/Restaurants',function(Request $request,Response $response,$arg){
    $_input = $request->getParsedBody();
    $City = $_input['city'];
    $name = $_input['name'];
    $all = $_input['all'];
    $data1 = $_input['data1'];
    $data2 = $_input['data2'];
    $sql;
    if($all=="yes")
    $sql = "SELECT * FROM restorantdetails";
    else
    $sql = "SELECT * FROM restorantdetails WHERE (city='".$City."' OR restaurant_name = '".$name."')AND overall_review BETWEEN ".$data1." AND ".$data2." ;" ;
    $db = new db();
    $db = $db->connect();
    $stmt = $db->query($sql);
    $result = $stmt->fetchAll(PDO::FETCH_OBJ);
    $db = null;
    echo json_encode($result);
});

$app->post('/Coin',function(Request $request,Response $response,$arg){
    

    $_input = $request->getParsedBody();
    $userid = $_input['userid'];
    $db = new db();
    $db = $db->connect();
    $sql = "SELECT coins FROM userdetails WHERE Userid='".$userid."';" ;
    $stmt = $db->query($sql);
    $result = $stmt->fetchAll(PDO::FETCH_OBJ);
    $db = null;
    echo json_encode($result);
});

$app->post('/UploadReview',function(Request $request,Response $response,$arg){
    

    $_input = $request->getParsedBody();
    $userid = $_input['userid'];
    $rid = $_input['restaurantid'];
    $rat1 = $_input['rat1'];
    $rat2 = $_input['rat2'];
    $rat3 = $_input['rat3'];
    $rat = $_input['rat'];
    $review = $_input['review'];
    $count=$_input['count'];
    $coins=$_input['coins'];
    $db = new db();
    $db = $db->connect();
    $sql = "INSERT INTO reviews (`restaurant_id`, `Userid`, `Food_Beverage`, `Service`, `Ambience`, `Review`) VALUES (:rid,:userid,:food,:ser,:amb,:re);" ;
    $stmt = $db->prepare($sql);
    $stmt->bindParam(':rid',$rid);
    $stmt->bindParam(':userid',$userid);
    $stmt->bindParam(':food',$rat1);
    $stmt->bindParam(':ser',$rat2);
    $stmt->bindParam(':amb',$rat3);
    $stmt->bindParam(':re',$review);
    $stmt->execute();

    $rat = floatval($rat);

    $sql="UPDATE restorantdetails SET `overall_review`=".$rat.", `review_count`=".$count." WHERE restaurant_id=".$rid."";
    $stmt = $db->prepare($sql);
    $stmt->execute();

    try{
    $sql="UPDATE userdetails SET `coins`=".$coins." WHERE Userid='".$userid."'";
    $stmt = $db->prepare($sql);
    $stmt->execute();
    $db=null;
    }
    catch(PDOException $ex)
    {
        echo $ex->getMessage();
    }
});

$app->get('/Cities',function(Request $request,Response $response,$arg){
    $sql = "SELECT DISTINCT city FROM restorantdetails";
    $db = new db();
    $db = $db->connect();
    $stmt = $db->query($sql);
    $result = $stmt->fetchAll(PDO::FETCH_OBJ);
    $db = null;
    echo json_encode($result);
});

$app->run();

