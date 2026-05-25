#pragma once
#include <QObject>
#include <QVector3D>

class TravelController : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QVector3D position READ position NOTIFY positionChanged)
    Q_PROPERTY(QVector3D velocity READ velocity NOTIFY velocityChanged)
    Q_PROPERTY(float speed READ speed WRITE setSpeed NOTIFY speedChanged)
    Q_PROPERTY(bool accelerating READ accelerating NOTIFY acceleratingChanged)

public:
    explicit TravelController(QObject *parent = nullptr);
    ~TravelController();

    QVector3D position() const { return m_position; }
    QVector3D velocity() const { return m_velocity; }
    float speed() const { return m_speed; }
    bool accelerating() const { return m_accelerating; }

    void setSpeed(float speed);

    Q_INVOKABLE void moveForward();
    Q_INVOKABLE void moveBackward();
    Q_INVOKABLE void moveLeft();
    Q_INVOKABLE void moveRight();
    Q_INVOKABLE void moveUp();
    Q_INVOKABLE void moveDown();
    Q_INVOKABLE void stopMovement();
    Q_INVOKABLE void updateCamera(float deltaTime);
    Q_INVOKABLE void setLookDirection(float pitch, float yaw);

signals:
    void positionChanged();
    void velocityChanged();
    void speedChanged();
    void acceleratingChanged();

private:
    void updateAcceleration();

    QVector3D m_position = {0, 0, 0};
    QVector3D m_velocity = {0, 0, 0};
    QVector3D m_acceleration = {0, 0, 0};
    QVector3D m_lookDirection = {0, 0, -1};

    float m_speed = 1.0f;
    float m_maxSpeed = 100.0f;
    float m_acceleration_rate = 0.5f;

    bool m_accelerating = false;
    bool m_moveForward = false;
    bool m_moveBackward = false;
    bool m_moveLeft = false;
    bool m_moveRight = false;
    bool m_moveUp = false;
    bool m_moveDown = false;
};
