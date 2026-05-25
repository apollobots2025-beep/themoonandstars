#include "TravelController.h"
#include <cmath>
#include <QtGlobal>

TravelController::TravelController(QObject *parent)
    : QObject(parent)
{
}

TravelController::~TravelController()
{
}

void TravelController::setSpeed(float speed)
{
    if (m_speed != speed) {
        m_speed = qMax(0.0f, qMin(speed, m_maxSpeed));
        emit speedChanged();
    }
}

void TravelController::moveForward()
{
    m_moveForward = true;
    updateAcceleration();
}

void TravelController::moveBackward()
{
    m_moveBackward = true;
    updateAcceleration();
}

void TravelController::moveLeft()
{
    m_moveLeft = true;
    updateAcceleration();
}

void TravelController::moveRight()
{
    m_moveRight = true;
    updateAcceleration();
}

void TravelController::moveUp()
{
    m_moveUp = true;
    updateAcceleration();
}

void TravelController::moveDown()
{
    m_moveDown = true;
    updateAcceleration();
}

void TravelController::stopMovement()
{
    m_moveForward = false;
    m_moveBackward = false;
    m_moveLeft = false;
    m_moveRight = false;
    m_moveUp = false;
    m_moveDown = false;
    updateAcceleration();
}

void TravelController::updateCamera(float deltaTime)
{
    // Simple velocity-based position update
    m_position += m_velocity * deltaTime;
    emit positionChanged();
}

void TravelController::setLookDirection(float pitch, float yaw)
{
    // Convert pitch and yaw to direction vector
    float cosPitch = std::cos(pitch);
    m_lookDirection = QVector3D(
        std::sin(yaw) * cosPitch,
        std::sin(pitch),
        -std::cos(yaw) * cosPitch
    ).normalized();
}

void TravelController::updateAcceleration()
{
    QVector3D newAcceleration(0, 0, 0);
    
    if (m_moveForward)
        newAcceleration += m_lookDirection;
    if (m_moveBackward)
        newAcceleration -= m_lookDirection;
    if (m_moveRight)
        newAcceleration += QVector3D::crossProduct(m_lookDirection, QVector3D(0, 1, 0)).normalized();
    if (m_moveLeft)
        newAcceleration -= QVector3D::crossProduct(m_lookDirection, QVector3D(0, 1, 0)).normalized();
    if (m_moveUp)
        newAcceleration += QVector3D(0, 1, 0);
    if (m_moveDown)
        newAcceleration -= QVector3D(0, 1, 0);

    m_acceleration = newAcceleration.normalized() * m_acceleration_rate * m_speed;
    
    if (m_moveForward || m_moveBackward || m_moveLeft || m_moveRight || m_moveUp || m_moveDown) {
        m_velocity += m_acceleration;
        if (m_velocity.length() > m_speed) {
            m_velocity = m_velocity.normalized() * m_speed;
        }
        if (!m_accelerating) {
            m_accelerating = true;
            emit acceleratingChanged();
        }
    } else {
        // Deceleration
        m_velocity *= 0.95f;
        if (m_velocity.length() < 0.01f) {
            m_velocity = QVector3D(0, 0, 0);
            if (m_accelerating) {
                m_accelerating = false;
                emit acceleratingChanged();
            }
        }
    }
    
    emit velocityChanged();
}
