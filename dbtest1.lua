using UnityEngine;
using System.Collections;

public class DeathBallGame : MonoBehaviour
{
    [Header("Player Settings")]
    public Transform player;
    public float parryRadius = 2f;
    public Color parryCircleColor = Color.red;
    public float parryCooldown = 0.5f;
    
    [Header("Ball Settings")]
    public GameObject ballPrefab;
    public float ballSpeed = 10f;
    public float curveIntensity = 1f;
    public float minSpawnInterval = 1f;
    public float maxSpawnInterval = 3f;
    
    private bool canParry = true;
    private GameObject currentBall;
    private LineRenderer parryCircle;
    private Vector3 curveDirection;
    
    void Start()
    {
        CreateParryCircle();
        StartCoroutine(SpawnBallRoutine());
    }
    
    void CreateParryCircle()
    {
        GameObject circleObj = new GameObject("ParryCircle");
        circleObj.transform.SetParent(player);
        circleObj.transform.localPosition = Vector3.zero;
        
        parryCircle = circleObj.AddComponent<LineRenderer>();
        parryCircle.material = new Material(Shader.Find("Sprites/Default"));
        parryCircle.startColor = parryCircleColor;
        parryCircle.endColor = parryCircleColor;
        parryCircle.startWidth = 0.1f;
        parryCircle.endWidth = 0.1f;
        parryCircle.positionCount = 51; // For a smooth circle
        parryCircle.loop = true;
        
        DrawCircle();
    }
    
    void DrawCircle()
    {
        float angle = 0f;
        for (int i = 0; i < parryCircle.positionCount; i++)
        {
            float x = Mathf.Sin(Mathf.Deg2Rad * angle) * parryRadius;
            float z = Mathf.Cos(Mathf.Deg2Rad * angle) * parryRadius;
            parryCircle.SetPosition(i, new Vector3(x, 0f, z));
            angle += (360f / parryCircle.positionCount);
        }
    }
    
    IEnumerator SpawnBallRoutine()
    {
        while (true)
        {
            yield return new WaitForSeconds(Random.Range(minSpawnInterval, maxSpawnInterval));
            
            if (currentBall == null)
            {
                SpawnBall();
            }
        }
    }
    
    void SpawnBall()
    {
        Vector3 spawnPosition = new Vector3(
            Random.Range(-10f, 10f),
            0f,
            Random.Range(-10f, 10f)
        );
        
        currentBall = Instantiate(ballPrefab, spawnPosition, Quaternion.identity);
        curveDirection = new Vector3(
            Random.Range(-1f, 1f),
            0f,
            Random.Range(-1f, 1f)
        ).normalized * curveIntensity;
        
        // Initial direction towards player with some randomness
        Vector3 directionToPlayer = (player.position - spawnPosition).normalized;
        directionToPlayer += new Vector3(
            Random.Range(-0.3f, 0.3f),
            0f,
            Random.Range(-0.3f, 0.3f)
        );
        
        Rigidbody ballRb = currentBall.GetComponent<Rigidbody>();
        ballRb.velocity = directionToPlayer * ballSpeed;
    }
    
    void Update()
    {
        if (currentBall != null)
        {
            // Apply curve to ball's movement
            Rigidbody ballRb = currentBall.GetComponent<Rigidbody>();
            ballRb.AddForce(curveDirection * Time.deltaTime, ForceMode.VelocityChange);
            
            // Check for parry collision
            float distanceToPlayer = Vector3.Distance(currentBall.transform.position, player.position);
            if (distanceToPlayer <= parryRadius && canParry)
            {
                ParryBall();
            }
        }
    }
    
    void ParryBall()
    {
        canParry = false;
        
        // Calculate reflection direction with some randomness
        Vector3 incomingDirection = currentBall.GetComponent<Rigidbody>().velocity.normalized;
        Vector3 reflectDirection = Vector3.Reflect(incomingDirection, 
            (currentBall.transform.position - player.position).normalized);
        
        // Add randomness to the reflection
        reflectDirection += new Vector3(
            Random.Range(-0.5f, 0.5f),
            0f,
            Random.Range(-0.5f, 0.5f)
        );
        
        // Apply new direction with increased speed
        currentBall.GetComponent<Rigidbody>().velocity = reflectDirection.normalized * ballSpeed * 1.5f;
        
        // Change curve direction after parry
        curveDirection = new Vector3(
            Random.Range(-1f, 1f),
            0f,
            Random.Range(-1f, 1f)
        ).normalized * curveIntensity * 2f;
        
        // Visual feedback
        StartCoroutine(ParryEffect());
        StartCoroutine(ParryCooldown());
    }
    
    IEnumerator ParryEffect()
    {
        parryCircle.startColor = Color.white;
        parryCircle.endColor = Color.white;
        yield return new WaitForSeconds(0.1f);
        parryCircle.startColor = parryCircleColor;
        parryCircle.endColor = parryCircleColor;
    }
    
    IEnumerator ParryCooldown()
    {
        yield return new WaitForSeconds(parryCooldown);
        canParry = true;
    }
    
    void OnDrawGizmos()
    {
        if (player != null)
        {
            Gizmos.color = Color.red;
            Gizmos.DrawWireSphere(player.position, parryRadius);
        }
    }
}
