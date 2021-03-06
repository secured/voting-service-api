import {
  insert,
  update as updateQuery,
  remove as removeQuery, query
} from './../../lib/database'
import { getCurrentUnixTimeStamp } from '../../lib/time-stamp'

export async function findOneById (id) {
  const result = await query('SELECT * FROM poll_result WHERE id = ?', [id])
  return Array.isArray(result) ? result[0] || null : null
}

export async function findClosedPollResults (eventId, page, pageSize) {
  const offset = page * pageSize
  return await query(`
    SELECT poll_result.*
    FROM poll_result
    INNER JOIN poll ON poll.id = poll_result.poll_id
    WHERE poll.event_id = ?
    AND poll_result.closed = ?
    ORDER BY create_datetime DESC
    LIMIT ? OFFSET ?
  `,
  [eventId, true, pageSize, offset])
}

export async function findLeftAnswersCount (pollResultId) {
  const result = await query(`
    SELECT poll_result.id as poll_result_id,
     poll_result.max_votes,
     poll_result.max_vote_cycles,
    (SELECT COUNT(*) FROM poll_user_voted WHERE poll_user_voted.poll_result_id = poll_result.id) AS poll_user_vote_cycles,
    (SELECT COUNT(poll_user_voted.id) FROM poll_user_voted WHERE poll_user_voted.poll_result_id = poll_result.id) AS poll_user_voted_count,
    (SELECT COUNT(*) FROM poll_answer WHERE poll_answer.poll_result_id = poll_result.id) AS poll_answers_count,
    (SELECT COUNT(poll_user.id) FROM poll_user WHERE poll_user.poll_id = poll_result.poll_id) AS poll_user_count
    FROM poll_result
    WHERE poll_result.id = ?
    GROUP BY poll_result_id
    HAVING poll_answers_count < poll_result.max_votes AND poll_user_vote_cycles < poll_result.max_vote_cycles
  `, [pollResultId])
  return Array.isArray(result) ? result[0] || null : null
}

export async function closePollResult (id) {
  await query(
    'UPDATE poll_result SET closed = ? WHERE id = ?',
    [1, id]
  )
}

export async function findActivePoll (eventId) {
  const result = await query(`
  SELECT
    poll_result.id AS id,
    poll.title AS title,
    poll_result.max_votes,
    (SELECT COUNT(poll_user.id) FROM poll_user WHERE poll_user.poll_id = poll.id) AS poll_user_count,
    (SELECT COUNT(poll_user_voted.id) FROM poll_user_voted WHERE poll_user_voted.poll_result_id = poll_result.id AND poll_user_voted.vote_cycle = 1) AS poll_user_voted_count,
    (SELECT COUNT(poll_answer.id) FROM poll_answer WHERE poll_answer.poll_result_id = poll_result.id) AS poll_answers_count
  FROM poll
  INNER JOIN poll_result ON poll.id = poll_result.poll_id
  WHERE poll.event_id = ? AND poll_result.closed = 0
  GROUP BY poll.id
  `,
  [eventId])
  return Array.isArray(result) ? result[0] || null : null
}

export async function findActivePollEventUser (eventId) {
  const result = await query(`
  SELECT 'new' AS state, poll.id AS poll, poll_result.id AS poll_result_id
  FROM poll
  INNER JOIN poll_result ON poll.id = poll_result.poll_id
  WHERE poll.event_id = ? AND poll_result.closed = 0
  GROUP BY poll.id
  `,
  [eventId])
  return Array.isArray(result) ? result[0] || null : null
}

export async function create (input) {
  input.createDatetime = getCurrentUnixTimeStamp()
  return await insert('poll_result', input)
}

export async function update (input) {
  input.modifiedDatetime = getCurrentUnixTimeStamp()
  await updateQuery('poll_result', input)
}

export async function remove (id) {
  return await removeQuery('poll_result', id)
}
