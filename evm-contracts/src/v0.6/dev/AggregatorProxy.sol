pragma solidity 0.6.2;

import "./AggregatorInterface.sol";
import "./Disableable.sol";
import "../Owned.sol";
import "./Whitelisted.sol";

/**
 * @title A trusted proxy for updating where current answers are read from
 * @notice This contract provides a consistent address for the
 * CurrentAnwerInterface but delegates where it reads from to the owner, who is
 * trusted to update it and disable it.
 */
contract AggregatorProxy is AggregatorInterface, Owned, Disableable {

  AggregatorInterface public aggregator;

  constructor(address _aggregator) public Owned() {
    setAggregator(_aggregator);
  }

  /**
   * @notice Reads the current answer from aggregator delegated to.
   */
  function latestAnswer()
    external
    view
    virtual
    override
    returns (int256)
  {
    return _latestAnswer();
  }

  /**
   * @notice Reads the last updated height from aggregator delegated to.
   */
  function latestTimestamp()
    external
    view
    virtual
    override
    returns (uint256)
  {
    return _latestTimestamp();
  }

  /**
   * @notice get past rounds answers
   * @param _roundId the answer number to retrieve the answer for
   */
  function getAnswer(uint256 _roundId)
    external
    view
    virtual
    override
    returns (int256)
  {
    return _getAnswer(_roundId);
  }

  /**
   * @notice get block timestamp when an answer was last updated
   * @param _roundId the answer number to retrieve the updated timestamp for
   */
  function getTimestamp(uint256 _roundId)
    external
    view
    virtual
    override
    returns (uint256)
  {
    return _getTimestamp(_roundId);
  }

  /**
   * @notice get the latest completed round where the answer was updated
   */
  function latestRound()
    external
    view
    virtual
    override
    returns (uint256)
  {
    return _latestRound();
  }

  /**
   * @notice Allows the owner to update the aggregator address.
   * @param _aggregator The new address for the aggregator contract
   */
  function setAggregator(address _aggregator)
    public
    onlyOwner()
  {
    aggregator = AggregatorInterface(_aggregator);
  }

  /*
   * Internal
   */

  function _latestAnswer()
    internal
    view
    onlyWhenEnabled()
    returns (int256)
  {
    return aggregator.latestAnswer();
  }

  function _latestTimestamp()
    internal
    view
    onlyWhenEnabled()
    returns (uint256)
  {
    return aggregator.latestTimestamp();
  }

  function _getAnswer(uint256 _roundId)
    internal
    view
    onlyWhenEnabled()
    returns (int256)
  {
    return aggregator.getAnswer(_roundId);
  }

  function _getTimestamp(uint256 _roundId)
    internal
    view
    onlyWhenEnabled()
    returns (uint256)
  {
    return aggregator.getTimestamp(_roundId);
  }

  function _latestRound()
    internal
    view
    onlyWhenEnabled()
    returns (uint256)
  {
    return aggregator.latestRound();
  }
}
